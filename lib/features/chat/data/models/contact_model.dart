// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chattin/features/chat/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    required super.uid,
    required super.displayName,
    required super.about,
    required super.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'about': about,
      'imageUrl': imageUrl,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      uid: map['uid'] != null ? map['uid'] as String : "",
      displayName:
          map['displayName'] != null ? map['displayName'] as String : "",
      about: map['about'] != null ? map['about'] as String : "",
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
