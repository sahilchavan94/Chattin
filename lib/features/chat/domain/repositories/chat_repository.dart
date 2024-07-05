import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/message_entity.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, List<ContactEntity>>> getAppContacts(
    List<String> phoneNumbers,
  );
  Future<Either<Failure, String>> sendTextMessage({
    required String text,
    required String recieverId,
    required UserEntity sender,
  });
  Stream<List<MessageEntity>> getChatStream({
    required String recieverId,
    required String senderId,
  });
  Stream<List<ContactEntity>> getChatContacts(String uid);
  Stream<Status> getChatStatus(String uid);
  Future<Either<Failure, void>> setChatStatus({
    required Status status,
    required String uid,
  });
  Future<Either<Failure, String>> sendFileMessage({
    required String downloadedUrl,
    required String recieverId,
    required UserEntity sender,
    required String messageId,
    required MessageType messageType,
  });
  Future<Either<Failure, void>> setMessageStatus({
    required String receiverUserId,
    required String messageId,
    required String senderId,
  });
  Future<Either<Failure, void>> sendReplyMessage({
    required String text,
    required String repliedTo,
    required String recieverId,
    required String senderId,
    required MessageType repliedToType,
  });
}
