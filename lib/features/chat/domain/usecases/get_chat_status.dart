import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';

class GetChatStatusUseCase {
  final ChatRepository chatRepository;

  GetChatStatusUseCase({required this.chatRepository});

  Stream<Status> call(String uid) {
    return chatRepository.getChatStatus(uid);
  }
}
