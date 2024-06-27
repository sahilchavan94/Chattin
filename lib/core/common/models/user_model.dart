// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chattin/core/common/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.displayName,
    required super.photoUrl,
    required super.email,
    required super.phoneNumber,
    required super.phoneCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'photoUrl': photoUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'phoneCode': phoneCode,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
