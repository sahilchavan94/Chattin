import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, List<ContactEntity>>> getAppContacts(
    List<String> phoneNumbers,
  );
}
