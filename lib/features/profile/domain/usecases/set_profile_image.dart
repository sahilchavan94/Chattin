import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class SetProfileImageUseCase {
  final ProfileRepository profileRepository;
  const SetProfileImageUseCase({required this.profileRepository});

  Future<Either<Failure, String>> call(
      {required String uid, required String imageUrl}) async {
    return await profileRepository.setProfileImage(
      uid: uid,
      imageUrl: imageUrl,
    );
  }
}
