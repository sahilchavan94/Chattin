import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddNewContactUseCase {
  final ChatRepository chatRepository;

  AddNewContactUseCase({required this.chatRepository});

  Future<Either<Failure, String>> call({
    required String displayName,
    required String phoneCode,
    required String phoneNumber,
  }) async {
    return await chatRepository.addNewContacts(
      displayName: displayName,
      phoneCode: phoneCode,
      phoneNumber: phoneNumber,
    );
  }
}
