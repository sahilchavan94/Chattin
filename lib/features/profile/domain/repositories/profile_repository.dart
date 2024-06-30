import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, UserEntity>> getProfileData(String uid);
}
