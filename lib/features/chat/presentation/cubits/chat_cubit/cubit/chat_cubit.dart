import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_contacts.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_status.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_stream.dart';
import 'package:chattin/features/chat/domain/usecases/send_message.dart';
import 'package:chattin/features/chat/domain/usecases/set_chat_status.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetChatStreamUseCase _getChatStreamUseCase;
  final GetChatContactsUseCase _getChatContactsUseCase;
  final GetChatStatusUseCase _getChatStatusUseCase;
  final SetChatStatusUseCase _setChatStatusUseCase;
  final FirebaseAuth _firebaseAuth;
  ChatCubit(
    this._sendMessageUseCase,
    this._getChatStreamUseCase,
    this._firebaseAuth,
    this._getChatContactsUseCase,
    this._getChatStatusUseCase,
    this._setChatStatusUseCase,
  ) : super(ChatState.initial());

  //method to send a chat message
  Future<void> sendMessage({
    required String text,
    required String recieverId,
    required UserEntity sender,
  }) async {
    final response = await _sendMessageUseCase.call(
      text: text,
      recieverId: recieverId,
      sender: sender,
    );
    response.fold(
      (l) {},
      (r) {},
    );
  }

  Stream<List<MessageEntity>> getChatStream({required String receiverId}) {
    final currentUser = _firebaseAuth.currentUser!;
    final response = _getChatStreamUseCase.call(
      senderId: currentUser.uid,
      receiver: receiverId,
    );
    return response;
  }

  //function to get the chat contacts stream
  Stream<List<ContactEntity>> getChatContacts() {
    final currentUser = _firebaseAuth.currentUser!;
    final response = _getChatContactsUseCase.call(currentUser.uid);
    return response;
  }

  //function to get the chat status stream
  Stream<Status> getChatStatus(String uid) {
    final response = _getChatStatusUseCase.call(uid);
    return response;
  }

  //function to set the chat status
  Future<void> setChatStatus({
    required Status status,
    required String uid,
  }) async {
    final response = await _setChatStatusUseCase.call(
      status: status,
      uid: uid,
    );
    response.fold(
      (l) {},
      (r) {},
    );
  }
}
