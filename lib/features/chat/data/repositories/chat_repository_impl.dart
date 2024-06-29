import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/chat/data/datasources/chat_remote_datasource.dart';
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
}
