import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';

class SendFileMessageUseCase {
  final ChatRepository chatRepository;

  SendFileMessageUseCase({required this.chatRepository});

  Future<Either<Failure, String>> call({
    required String downloadedUrl,
    required String recieverId,
    required String messageId,
    required UserEntity sender,
    required MessageType messageType,
  }) async {
    return await chatRepository.sendFileMessage(
      downloadedUrl: downloadedUrl,
      recieverId: recieverId,
      sender: sender,
      messageId: messageId,
      messageType: messageType,
    );
  }
}
