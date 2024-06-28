// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckVerificationStatusUseCase {
  final AuthRepository authRepository;
  CheckVerificationStatusUseCase({
    required this.authRepository,
  });

  Future<Either<Failure, String>> call() async {
    return await authRepository.checkVerificationStatus();
  }
}