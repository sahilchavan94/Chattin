import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProfileDataUseCase {
  final ProfileRepository profileRepository;
  const GetProfileDataUseCase({required this.profileRepository});

  Future<Either<Failure, UserEntity>> call(String uid) async {
    return await profileRepository.getProfileData(uid);
  }
}
