import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';

class GetChatStreamUseCase {
  final ChatRepository chatRepository;

  GetChatStreamUseCase({required this.chatRepository});

  Stream<List<MessageEntity>> call({
    required String senderId,
    required String receiver,
  }) {
    return chatRepository.getChatStream(
      recieverId: receiver,
      senderId: senderId,
    );
  }
}
