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
  Future<Either<Failure, String>> createAccountWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response =
          await authRemoteDataSourceImpl.createAccountWithEmailAndPassword(
        email,
        password,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(
          e.error,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailVerificationLink() async {
    try {
      final response =
          await authRemoteDataSourceImpl.sendEmailVerificationLink();
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(
          e.error,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> checkVerificationStatus() async {
    try {
      final response = await authRemoteDataSourceImpl.checkVerificationStatus();
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(
          e.error,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> setAccountDetails({
    required String displayName,
    required String phoneNumber,
    required String phoneCode,
    required String imageUrl,
  }) async {
    try {
      final response = await authRemoteDataSourceImpl.setAccountDetails(
        displayName: displayName,
        phoneNumber: phoneNumber,
        phoneCode: phoneCode,
        imageUrl: imageUrl,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(
          e.error,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>>
      checkTheAccountDetailsIfTheEmailIsVerified() async {
    try {
      final response = await authRemoteDataSourceImpl
          .checkTheAccountDetailsIfTheEmailIsVerified();
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(
          e.error,
        ),
      );
    }
  }
}
