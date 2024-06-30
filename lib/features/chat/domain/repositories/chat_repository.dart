import 'package:chattin/core/common/models/user_model.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, List<ContactEntity>>> getAppContacts(
    List<String> phoneNumbers,
  );
  Future<Either<Failure, String>> sendTextMessage({
    required String text,
    required String recieverId,
    required UserModel sender,
  });
}
