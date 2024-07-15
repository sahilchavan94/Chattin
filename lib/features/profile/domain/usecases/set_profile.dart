import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class SetProfileDataUseCase {
  final ProfileRepository profileRepository;
  const SetProfileDataUseCase({required this.profileRepository});

  Future<Either<Failure, String>> call({
    required String uid,
    required String displayName,
    required String phoneNumber,
    required String about,
  }) async {
    return await profileRepository.setProfileData(
      uid: uid,
      about: about,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );
  }
}
