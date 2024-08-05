import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';

//use case for fetching the previous chat contacts to which the user chatted with previously
class GetChatContactsUseCase {
  final ChatRepository chatRepository;

  GetChatContactsUseCase({required this.chatRepository});

  Stream<List<ContactEntity>> call(String uid) {
    return chatRepository.getChatContacts(uid);
  }
}
