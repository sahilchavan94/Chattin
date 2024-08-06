import 'package:chattin/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> createAccountWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<Failure, String>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<Failure, String>> sendEmailVerificationLink();

  Future<Either<Failure, String>> checkVerificationStatus();

  Future<Either<Failure, String>> setAccountDetails({
    required String displayName,
    required String phoneNumber,
    required String phoneCode,
    required String imageUrl,
  });

  Future<Either<Failure, String>> checkTheAccountDetailsIfTheEmailIsVerified();

  Future<Either<Failure, String>> signOutFromAccount();
}
