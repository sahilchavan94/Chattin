// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/helper_functions.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.displayName,
    required super.imageUrl,
    super.email,
    super.phoneNumber,
    super.phoneCode,
    super.about,
    super.status,
    super.joinedOn,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : '',
      displayName:
          map['displayName'] != null ? map['displayName'] as String : '',
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : '',
      email: map['email'] != null ? map['email'] as String : '',
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : '',
      phoneCode: map['phoneCode'] != null ? map['phoneCode'] as String : '',
      about: map['about'] != null
          ? map['about'] as String
          : 'Hello everyone, I\'m now on Chattin`!',
      status: map['status'] != null
          ? HelperFunctions.parseStatusType(map['status'] as String)
          : Status.unavailable,
      joinedOn: map['joinedOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['joinedOn'] as int)
          : null,
    );
  }
}
