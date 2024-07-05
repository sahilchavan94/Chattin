import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendReplyUseCase {
  final ChatRepository chatRepository;
  const SendReplyUseCase({required this.chatRepository});

  Future<Either<Failure, void>> call({
    required String text,
    required String repliedTo,
    required String recieverId,
    required MessageType repliedToType,
    required String senderId,
  }) async {
    return await chatRepository.sendReplyMessage(
      text: text,
      repliedTo: repliedTo,
      recieverId: recieverId,
      senderId: senderId,
      repliedToType: repliedToType,
    );
  }
}
