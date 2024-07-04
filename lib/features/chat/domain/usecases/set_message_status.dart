import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SetMessageStatusUseCase {
  final ChatRepository chatRepository;
  const SetMessageStatusUseCase({required this.chatRepository});

  Future<Either<Failure, void>> call({
    required String messageId,
    required String receiverId,
    required String senderId,
  }) async {
    return await chatRepository.setMessageStatus(
      receiverUserId: receiverId,
      messageId: messageId,
      senderId: senderId,
    );
  }
}
