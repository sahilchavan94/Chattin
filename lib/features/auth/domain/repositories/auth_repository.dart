import 'package:chattin/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> sendOtpOnPhone(String phoneNumber);
}
