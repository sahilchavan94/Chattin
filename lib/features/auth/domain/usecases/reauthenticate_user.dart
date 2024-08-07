// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ReauthenticateUser {
  final AuthRepository authRepository;
  ReauthenticateUser({
    required this.authRepository,
  });

  Future<Either<Failure, String>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.reauthenticateUser(
      email: email,
      password: password,
    );
  }
}
