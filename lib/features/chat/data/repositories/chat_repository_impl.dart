import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/common/models/user_model.dart';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:chattin/features/chat/data/models/message_model.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSourceImpl chatRemoteDataSourceImpl;

  ChatRepositoryImpl({required this.chatRemoteDataSourceImpl});
  @override
  Future<Either<Failure, List<ContactEntity>>> getAppContacts(
      List<String> phoneNumbers) async {
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

  //i need to know whether there I can use fpdart with streams : will research on it
  @override
  Stream<List<MessageModel>> getChatStream({
    required String recieverId,
    required String senderId,
  }) {
    final response = chatRemoteDataSourceImpl.getChatStream(
      recieverId: recieverId,
      senderId: senderId,
    );
    return response;
  }
}