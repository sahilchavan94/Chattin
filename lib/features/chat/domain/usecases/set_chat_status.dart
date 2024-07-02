import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SetChatStatusUseCase {
  final ChatRepository chatRepository;

  SetChatStatusUseCase({required this.chatRepository});

  Future<Either<Failure, void>> call({
    required Status status,
    required String uid,
  }) async {
    return await chatRepository.setChatStatus(
      status: status,
      uid: uid,
    );
  }
}
