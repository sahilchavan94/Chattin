// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/errors/exceptions.dart';

import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:chattin/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  AuthRepositoryImpl({
    required this.authRemoteDataSourceImpl,
  });
  @override
  Future<Either<Failure, String>> sendOtpOnPhone(String phoneNumber) async {
    try {
      return Right(
        await authRemoteDataSourceImpl.sendOtpOnPhone(
          phoneNumber,
        ),
      );
    } on ServerException catch (e) {
      return Left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
