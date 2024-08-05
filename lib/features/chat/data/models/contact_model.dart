// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    super.uid,
    super.about,
    super.lastMessage,
    super.timeSent,
    super.phoneNumber,
    required super.imageUrl,
    required super.displayName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'imageUrl': imageUrl,
      'lastMessage': lastMessage ?? ToastMessages.defaultFailureMessage,
      'timeSent': timeSent?.millisecondsSinceEpoch,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      uid: map['uid'] != null ? map['uid'] as String : "",
      displayName:
          map['displayName'] != null ? map['displayName'] as String : "",
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : "",
      about: map['about'] != null ? map['about'] as String : "",
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : "",
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : "",
      timeSent: map['timeSent'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int)
          : null,
    );
  }
}
