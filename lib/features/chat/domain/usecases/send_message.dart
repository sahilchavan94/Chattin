import 'package:chattin/core/common/models/user_model.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendMessageUseCase {
  final ChatRepository chatRepository;

  SendMessageUseCase({required this.chatRepository});

  Future<Either<Failure, String>> call({
    required String text,
    required String recieverId,
    required UserModel sender,
  }) async {
    return await chatRepository.sendTextMessage(
      text: text,
      sender: sender,
      recieverId: recieverId,
    );
  }
}
