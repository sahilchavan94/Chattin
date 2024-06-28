// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/helper_functions.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.displayName,
    required super.photoUrl,
    required super.email,
    required super.phoneNumber,
    required super.phoneCode,
    required super.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'photoUrl': photoUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'phoneCode': phoneCode,
      'status': status,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayName:
          map['displayName'] != null ? map['displayName'] as String : '',
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : '',
      email: map['email'] != null ? map['email'] as String : '',
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : '',
      phoneCode: map['phoneNumber'] != null ? map['phoneNumber'] as String : '',
      status: map['status'] != null
          ? HelperFunctions.parseStatusType(map['status'] as String)
          : Status.unavailable,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
