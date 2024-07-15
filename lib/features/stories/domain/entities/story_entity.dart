import 'package:chattin/core/common/entities/user_entity.dart';

class StoryEntity {
  final String uid;
  final String phoneNumber;
  final List imageUrlList;
  final UserEntity? userEntity;

  StoryEntity({
    required this.uid,
    required this.phoneNumber,
    required this.imageUrlList,
    this.userEntity,
  });
}
