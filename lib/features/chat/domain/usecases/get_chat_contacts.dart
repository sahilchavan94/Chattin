import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';

class GetChatContactsUseCase {
  final ChatRepository chatRepository;

  GetChatContactsUseCase({required this.chatRepository});

  Stream<List<ContactEntity>> call(String uid) {
    return chatRepository.getChatContacts(uid);
  }
}
