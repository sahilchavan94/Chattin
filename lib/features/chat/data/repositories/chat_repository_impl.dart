// ignore_for_file: void_checks

import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/common/models/user_model.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSourceImpl chatRemoteDataSourceImpl;

  ChatRepositoryImpl({required this.chatRemoteDataSourceImpl});
  @override
  Future<Either<Failure, List<ContactEntity>>> getAppContacts(
    List<String> phoneNumbers,
  ) async {
    try {
      final response = await chatRemoteDataSourceImpl.getAppContacts(
        phoneNumbers,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> sendTextMessage({
    required String text,
    required String recieverId,
    required UserEntity sender,
  }) async {
    try {
      final senderModel = UserModel(
        uid: sender.uid,
        displayName: sender.displayName,
        imageUrl: sender.imageUrl,
      );
      final response = await chatRemoteDataSourceImpl.sendTextMessage(
        text: text,
        recieverId: recieverId,
        sender: senderModel,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> sendFileMessage({
    required String downloadedUrl,
    required String recieverId,
    required UserEntity sender,
    required String messageId,
    required MessageType messageType,
  }) async {
    try {
      final senderModel = UserModel(
        uid: sender.uid,
        displayName: sender.displayName,
        imageUrl: sender.imageUrl,
      );
      final response = await chatRemoteDataSourceImpl.sendFileMessage(
        downloadedUrl: downloadedUrl,
        recieverId: recieverId,
        messageId: messageId,
        sender: senderModel,
        messageType: messageType,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Stream<List<MessageEntity>> getChatStream({
    required String recieverId,
    required String senderId,
  }) {
    final response = chatRemoteDataSourceImpl.getChatStream(
      recieverId: recieverId,
      senderId: senderId,
    );
    return response;
  }

  @override
  Stream<List<ContactEntity>> getChatContacts(String uid) {
    final response = chatRemoteDataSourceImpl.getChatContacts(uid);
    return response;
  }

  @override
  Stream<Status> getChatStatus(String uid) {
    final response = chatRemoteDataSourceImpl.getChatStatus(uid);
    return response;
  }

  @override
  Future<Either<Failure, void>> setChatStatus({
    required Status status,
    required String uid,
  }) async {
    try {
      final response = await chatRemoteDataSourceImpl.setChatStatus(
        status: status,
        uid: uid,
      );
      return Right(response);
    } catch (e) {
      return Left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> setMessageStatus({
    required String receiverUserId,
    required String messageId,
    required String senderId,
  }) async {
    try {
      final response = await chatRemoteDataSourceImpl.setMessageStatus(
        receiverUserId: receiverUserId,
        messageId: messageId,
        senderId: senderId,
      );
      return Right(response);
    } catch (e) {
      return Left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> sendReplyMessage({
    required String text,
    required String repliedTo,
    required String recieverId,
    required MessageType repliedToType,
    required String senderId,
  }) async {
    try {
      final response = await chatRemoteDataSourceImpl.sendReplyMessage(
        repliedTo: repliedTo,
        text: text,
        recieverId: recieverId,
        senderId: senderId,
        repliedToType: repliedToType,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> deleteMessageForSender({
    required String messageId,
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final response = await chatRemoteDataSourceImpl.deleteMessageForSender(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
      );
      return Right(response);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> deleteMessageForEveryone({
    required String messageId,
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final response = await chatRemoteDataSourceImpl.deleteMessageForEveryone(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
      );
      return Right(response);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> addNewContacts({
    required String displayName,
    required String phoneCode,
    required String phoneNumber,
  }) async {
    try {
      final response = await chatRemoteDataSourceImpl.addNewContacts(
        displayName: displayName,
        phoneCode: phoneCode,
        phoneNumber: phoneNumber,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(e.error),
      );
    }
  }

  @override
  Future<Either<Failure, String>> forwardMessage({
    required String text,
    required List<String> receiverIdList,
    required UserEntity sender,
    required MessageType messageType,
  }) async {
    try {
      final senderModel = UserModel(
        uid: sender.uid,
        displayName: sender.displayName,
        imageUrl: sender.imageUrl,
      );
      final response = await chatRemoteDataSourceImpl.forwardMessage(
        text: text,
        receiverIdList: receiverIdList,
        sender: senderModel,
        messageType: messageType,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(e.error),
      );
    }
  }
}
