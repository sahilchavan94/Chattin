import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetContactsUseCase {
  final ChatRepository chatRepository;

  GetContactsUseCase({required this.chatRepository});

  Future<Either<Failure, List<ContactEntity>>> call(
      List<String> phoneNumbers) async {
    return await chatRepository.getAppContacts(phoneNumbers);
  }
}
