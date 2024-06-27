// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SetAccountDetailsUseCase {
  final AuthRepository authRepository;
  SetAccountDetailsUseCase({
    required this.authRepository,
  });

  Future<Either<Failure, String>> call({
    required String displayName,
    required String phoneNumber,
    required String phoneCode,
    required String imageUrl,
  }) async {
    return await authRepository.setAccountDetails(
      displayName: displayName,
      phoneNumber: phoneNumber,
      phoneCode: phoneCode,
      imageUrl: imageUrl,
    );
  }
}
