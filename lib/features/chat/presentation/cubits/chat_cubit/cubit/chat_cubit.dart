import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_contacts.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_stream.dart';
import 'package:chattin/features/chat/domain/usecases/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetChatStreamUseCase _getChatStreamUseCase;
  final GetChatContactsUseCase _getChatContactsUseCase;
  final FirebaseAuth _firebaseAuth;
  ChatCubit(
    this._sendMessageUseCase,
    this._getChatStreamUseCase,
    this._firebaseAuth,
    this._getChatContactsUseCase,
  ) : super(ChatState.initial());

  Stream<List<MessageEntity>> getChatStream({required String receiverId}) {
    final currentUser = _firebaseAuth.currentUser!;
    final response = _getChatStreamUseCase.call(
      senderId: currentUser.uid,
      receiver: receiverId,
    );
    return response;
  }

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

  //function to get the chat contacts stream
  Stream<List<ContactEntity>> getChatContacts() {
    final currentUser = _firebaseAuth.currentUser!;
    final response = _getChatContactsUseCase.call(currentUser.uid);
    return response;
  }
}
