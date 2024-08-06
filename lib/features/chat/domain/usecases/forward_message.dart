import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForwardMessageUseCase {
  final ChatRepository chatRepository;

  ForwardMessageUseCase({required this.chatRepository});

  Future<Either<Failure, String>> call({
    required String text,
    required List<String> receiverIdList,
    required UserEntity sender,
    required MessageType messageType,
  }) async {
    return await chatRepository.forwardMessage(
      text: text,
      receiverIdList: receiverIdList,
      sender: sender,
      messageType: messageType,
    );
  }
}
