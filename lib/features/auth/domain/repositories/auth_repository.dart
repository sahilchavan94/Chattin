import 'package:chattin/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> createAccountWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, String>> sendEmailVerificationLink();
  Future<Either<Failure, String>> checkVerificationStatus();
}
