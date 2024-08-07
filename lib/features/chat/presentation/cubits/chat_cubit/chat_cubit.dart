import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/common/features/upload/domain/usecases/general_upload.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:chattin/features/chat/domain/usecases/add_new_contact.dart';
import 'package:chattin/features/chat/domain/usecases/delete_message_for_everyone.dart';
import 'package:chattin/features/chat/domain/usecases/delete_message_for_sender.dart';
import 'package:chattin/features/chat/domain/usecases/forward_message.dart';
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
import 'package:go_router/go_router.dart';
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
  final DeleteMessageForSenderUseCase _deleteMessageForSenderUseCase;
  final DeleteMessageForEveryoneUseCase _deleteMessageForEveryoneUseCase;
  final AddNewContactUseCase _addNewContactUseCase;
  final ForwardMessageUseCase _forwardMessageUseCase;
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
    this._deleteMessageForSenderUseCase,
    this._deleteMessageForEveryoneUseCase,
    this._addNewContactUseCase,
    this._forwardMessageUseCase,
  ) : super(ChatState.initial()) {
    getChatContacts();
  }

  //method to send a text message in the chat
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
        showToast(
          content: ToastMessages.failedToSentLastMessage,
          type: ToastificationType.error,
        );
        emit(state.copyWith(sendingMessage: false));
      },
      (r) {
        emit(state.copyWith(sendingMessage: false));
      },
    );
  }

  //method to send a file message in the chat ( only images in our case )
  Future<void> sendFileMessage({
    required String recieverId,
    required UserEntity sender,
    required MessageType messageType,
    required File file,
  }) async {
    emit(state.copyWith(sendingMessage: true));
    final messageId = const Uuid().v1();
    final referencePath =
        'chats/${messageType.toStringValue()}/${sender.uid}/$recieverId/$messageId';

    final uploadResponse = await _generalUploadUseCase.call(
      file,
      referencePath,
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
          showToast(
            content: ToastMessages.failedToSentLastMessage,
            type: ToastificationType.error,
          );
          emit(state.copyWith(sendingMessage: false));
        },
        (r) {
          emit(state.copyWith(sendingMessage: false));
        },
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

  //method to fetch the chat stream i.e chats between two users
  void getChatStream({
    required String receiverId,
  }) {
    emit(
      state.copyWith(
        chatStreamStatus: ChatStreamStatus.loading,
      ),
    );
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
            chatStreamStatus: ChatStreamStatus.success,
            currentChatMessages: currentChats,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          chatStreamStatus: ChatStreamStatus.failure,
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
            chatOnOffStreamStatus: ChatOnOffStreamStatus.success,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          chatOnOffStreamStatus: ChatOnOffStreamStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  //method to set the chat status
  //as we are setting the chat online/offline status, no need to handle any states
  //as we are using streams to update the statuses
  Future<void> setChatOnOffStatus({
    required Status status,
    required String uid,
  }) async {
    try {
      await _setChatStatusUseCase.call(
        status: status,
        uid: uid,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  //method to set the message status
  //seen - unseen status, no need to handle states here as well
  Future<void> setMessageStatus({
    required String receiverId,
    required String senderId,
    required String messageId,
  }) async {
    try {
      await _setMessageStatusUseCase.call(
        receiverId: receiverId,
        senderId: senderId,
        messageId: messageId,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  //method to send reply to a message
  Future<void> sendReply({
    required String text,
    required String repliedTo,
    required String recieverId,
    required MessageType repliedToType,
    required String senderId,
  }) async {
    emit(state.copyWith(sendingMessage: true));

    final response = await _sendReplyUseCase.call(
      text: text,
      repliedTo: repliedTo,
      recieverId: recieverId,
      repliedToType: repliedToType,
      senderId: senderId,
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

  //method to get the chat contact's information
  Future<void> getChatContactInformation(String uid) async {
    emit(state.copyWith(
      chatContactInformationStatus: ChatContactInformationStatus.loading,
    ));
    final response = await _getProfileDataUseCase.call(uid);
    response.fold(
      (l) {
        showToast(
          content: ToastMessages.profileFailure,
          description: ToastMessages.defaultFailureDescription,
          type: ToastificationType.error,
        );
        emit(state.copyWith(
          chatContactInformationStatus: ChatContactInformationStatus.failure,
        ));
      },
      (r) {
        emit(state.copyWith(
          chatContactInformationStatus: ChatContactInformationStatus.success,
          chatContactInformation: r,
        ));
      },
    );
  }

  //method to delete the message from sender side
  //no need to handle the states here as we are deleting the message
  Future<void> deleteMessageForSender({
    required String messageId,
    required String senderId,
    required String receiverId,
  }) async {
    final response = await _deleteMessageForSenderUseCase.call(
      messageId: messageId,
      senderId: senderId,
      receiverId: receiverId,
    );
    response.fold((l) {
      showToast(
        content: l.message ?? ToastMessages.defaultFailureMessage,
        type: ToastificationType.error,
      );
    }, (r) {
      showToast(
        content: r,
        description: ToastMessages.messageDeleteForMeSuccessDesc,
        type: ToastificationType.success,
      );
    });
  }

  //method to delete the message for both sender and the receiver
  //no need to handle the states here as we are deleting the message
  Future<void> deleteMessageForEveryone({
    required String messageId,
    required String senderId,
    required String receiverId,
  }) async {
    final response = await _deleteMessageForEveryoneUseCase.call(
      messageId: messageId,
      senderId: senderId,
      receiverId: receiverId,
    );
    response.fold((l) {
      showToast(
        content: l.message ?? ToastMessages.defaultFailureMessage,
        type: ToastificationType.error,
      );
    }, (r) {
      showToast(
        content: r,
        type: ToastificationType.success,
      );
    });
  }

  //method to add a new contact in native device ( currently only configured for Android )
  Future<void> addNewContact({
    required String phoneNumber,
    required String phoneCode,
    required String displayName,
  }) async {
    final response = await _addNewContactUseCase.call(
      displayName: displayName,
      phoneCode: phoneCode,
      phoneNumber: phoneNumber,
    );
    response.fold((l) {
      showToast(
        content: l.message ?? ToastMessages.defaultFailureMessage,
        type: ToastificationType.error,
      );
    }, (r) {
      showToast(
        content: r,
        type: ToastificationType.success,
      );
      Constants.navigatorKey.currentState!.pop();
    });
  }

  //method to forward a message
  Future<void> forwardMessage({
    required String text,
    required List<String> receiverIdList,
    required UserEntity sender,
    required MessageType messageType,
  }) async {
    showToast(
      content: ToastMessages.forwardingMessages,
      type: ToastificationType.info,
    );
    final response = await _forwardMessageUseCase.call(
      text: text,
      receiverIdList: receiverIdList,
      sender: sender,
      messageType: messageType,
    );
    response.fold((l) {
      showToast(
        content: l.message ?? ToastMessages.forwardMessageFailure,
        description: ToastMessages.defaultFailureDescription,
        type: ToastificationType.error,
      );
    }, (r) {
      showToast(
        content: r,
        type: ToastificationType.success,
      );
      Constants.navigatorKey.currentContext!.go(
        RoutePath.chatContacts.path,
      );
    });
  }
}
