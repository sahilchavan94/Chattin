import 'package:chattin/features/chat/data/models/message_model.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';

class GetChatStreamUseCase {
  final ChatRepository chatRepository;

  GetChatStreamUseCase({required this.chatRepository});

  Stream<List<MessageModel>> call({
    required String senderId,
    required String receiver,
  }) {
    return chatRepository.getChatStream(
      recieverId: receiver,
      senderId: senderId,
    );
  }
}
