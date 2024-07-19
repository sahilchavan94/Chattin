import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/common/features/upload/domain/usecases/general_upload.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_contacts.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_status.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_stream.dart';
import 'package:chattin/features/chat/domain/usecases/send_file_message.dart';
import 'package:chattin/features/chat/domain/usecases/send_message.dart';
import 'package:chattin/features/chat/domain/usecases/send_reply_message.dart';
import 'package:chattin/features/chat/domain/usecases/set_chat_status.dart';
import 'package:chattin/features/chat/domain/usecases/set_message_status.dart';
import 'package:chattin/features/profile/domain/usecases/get_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  //use cases
  final SendMessageUseCase _sendMessageUseCase;
  final GetChatStreamUseCase _getChatStreamUseCase;
  final GetChatContactsUseCase _getChatContactsUseCase;
  final GetChatStatusUseCase _getChatStatusUseCase;
  final SetChatStatusUseCase _setChatStatusUseCase;
  final GeneralUploadUseCase _generalUploadUseCase;
  final SendFileMessageUseCase _sendFileMessageUseCase;
  final SetMessageStatusUseCase _setMessageStatusUseCase;
  final SendReplyUseCase _sendReplyUseCase;
  final GetProfileDataUseCase _getProfileDataUseCase;
  final FirebaseAuth _firebaseAuth;

  //stream subscription for the chat contacts
  StreamSubscription<List<ContactEntity>>? _chatContactStreamSubscription;
  StreamSubscription<List<MessageEntity>>? _chatMessagesStreamSubscription;
  StreamSubscription<Status>? _chatStatusStreamSubscription;

  ChatCubit(
    this._sendMessageUseCase,
    this._getChatStreamUseCase,
    this._firebaseAuth,
    this._getChatContactsUseCase,
    this._getChatStatusUseCase,
    this._setChatStatusUseCase,
    this._generalUploadUseCase,
    this._sendFileMessageUseCase,
    this._setMessageStatusUseCase,
    this._sendReplyUseCase,
    this._getProfileDataUseCase,
  ) : super(ChatState.initial()) {
    getChatContacts();
  }

  //method to send a chat message
  Future<void> sendMessage({
    required String text,
    required String recieverId,
    required UserEntity sender,
  }) async {
    emit(state.copyWith(sendingMessage: true));
    final response = await _sendMessageUseCase.call(
      text: text,
      recieverId: recieverId,
      sender: sender,
    );
    response.fold(
      (l) {
        emit(state.copyWith(sendingMessage: false));
      },
      (r) {
        emit(state.copyWith(sendingMessage: false));
      },
    );
  }

  Future<void> sendFileMessage({
    required String recieverId,
    required UserEntity sender,
    required MessageType messageType,
    required File file,
  }) async {
    emit(state.copyWith(sendingMessage: true));
    final messageId = const Uuid().v1();
    final uploadResponse = await _generalUploadUseCase.call(
      file,
      'chats/${messageType.toStringValue()}/${sender.uid}/$recieverId/$messageId',
    );
    if (uploadResponse.isRight()) {
      final uploadedImageUrl = uploadResponse.getOrElse((l) => "");
      final response = await _sendFileMessageUseCase.call(
        downloadedUrl: uploadedImageUrl,
        recieverId: recieverId,
        sender: sender,
        messageId: messageId,
        messageType: messageType,
      );
      response.fold(
        (l) {
          emit(state.copyWith(sendingMessage: false));
        },
        (r) {
          emit(state.copyWith(sendingMessage: false));
        },
      );
    }
  }

  void getChatStream({
    required String receiverId,
  }) {
    emit(state.copyWith(fetchingCurrentChats: true));
    final uid = _firebaseAuth.currentUser!.uid;
    _chatMessagesStreamSubscription?.cancel();
    try {
      _chatMessagesStreamSubscription = _getChatStreamUseCase
          .call(
        receiver: receiverId,
        senderId: uid,
      )
          .listen((currentChats) {
        emit(
          state.copyWith(
            currentChatMessages: currentChats,
            fetchingCurrentChats: false,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          chatStatus: ChatStatus.failure,
          fetchingCurrentChats: false,
          message: e.toString(),
        ),
      );
    }
  }

  //method to get the chat contacts stream
  void getChatContacts() {
    final currentUser = _firebaseAuth.currentUser!;
    _chatContactStreamSubscription?.cancel();

    try {
      _chatContactStreamSubscription =
          _getChatContactsUseCase.call(currentUser.uid).listen((contacts) {
        emit(
          state.copyWith(
            chatContacts: contacts,
            chatStatus: ChatStatus.success,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          chatStatus: ChatStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  //method to get the current chat status stream
  void getChatStatus(String uid) {
    _chatStatusStreamSubscription?.cancel();
    try {
      _chatStatusStreamSubscription =
          _getChatStatusUseCase.call(uid).listen((status) {
        emit(
          state.copyWith(
            currentChatStatus: status,
            chatStatus: ChatStatus.success,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          chatStatus: ChatStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  //function to set the chat status
  Future<void> setChatStatus({
    required Status status,
    required String uid,
  }) async {
    await _setChatStatusUseCase.call(
      status: status,
      uid: uid,
    );
  }

  //function to set the message status
  Future<void> setMessageStatus({
    required String receiverId,
    required String senderId,
    required String messageId,
  }) async {
    await _setMessageStatusUseCase.call(
      receiverId: receiverId,
      senderId: senderId,
      messageId: messageId,
    );
  }

  //sending reply to a message
  Future<void> sendReply({
    required String text,
    required String repliedTo,
    required String recieverId,
    required MessageType repliedToType,
    required String senderId,
  }) async {
    emit(state.copyWith(chatStatus: ChatStatus.loading));
    final response = await _sendReplyUseCase.call(
      text: text,
      repliedTo: repliedTo,
      recieverId: recieverId,
      repliedToType: repliedToType,
      senderId: senderId,
    );
    response.fold(
      (l) {
        emit(state.copyWith(chatStatus: ChatStatus.failure));
      },
      (r) {
        emit(state.copyWith(chatStatus: ChatStatus.success));
      },
    );
  }

  // void notifyNewMessage({required bool newMessageFlag}) {
  //   emit(state.copyWith(isNewMessage: newMessageFlag));
  // }

  //method to get the chat contact's information
  Future<void> getChatContactInformation(String uid) async {
    emit(state.copyWith(fetchingUserInfo: true));
    final response = await _getProfileDataUseCase.call(uid);
    response.fold(
      (l) {
        emit(state.copyWith(
          fetchingUserInfo: null,
        ));
        showToast(
          content: ToastMessages.profileFailure,
          type: ToastificationType.error,
          description: ToastMessages.defaultFailureDescription,
        );
      },
      (r) {
        emit(state.copyWith(
          fetchingUserInfo: false,
          chatContactInformation: r,
        ));
      },
    );
  }
}
