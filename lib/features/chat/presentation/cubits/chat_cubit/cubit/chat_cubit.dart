import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/features/chat/data/models/message_model.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_stream.dart';
import 'package:chattin/features/chat/domain/usecases/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetChatStreamUseCase getChatStreamUseCase;
  final FirebaseAuth firebaseAuth;
  ChatCubit(
    this.sendMessageUseCase,
    this.getChatStreamUseCase,
    this.firebaseAuth,
  ) : super(ChatState.initial());

  Stream<List<MessageModel>> getChatStream({required String receiverId}) {
    final currentUser = firebaseAuth.currentUser!;
    final response = getChatStreamUseCase.call(
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
    final response = await sendMessageUseCase.call(
      text: text,
      recieverId: recieverId,
      sender: sender,
    );
    response.fold(
      (l) {},
      (r) {},
    );
  }
}
