// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel(
      {required super.senderId,
      required super.receiverId,
      required super.text,
      required super.timeSent,
      required super.messageId,
      required super.status,
      required super.messageType});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timeSent': timeSent!.millisecondsSinceEpoch,
      'messageId': messageId,
      'status': status,
      'messageType': messageType.toStringValue(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] != null ? map['senderId'] as String : "",
      receiverId: map['receiverId'] != null ? map['receiverId'] as String : "",
      text: map['text'] != null ? map['text'] as String : "",
      timeSent: map['timeSent'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int)
          : null,
      messageId: map['messageId'] != null ? map['messageId'] as String : "",
      status: map['status'] ?? false,
      messageType: map['messageType'] != null
          ? (map['messageType'] as String).toStringValue()
          : MessageType.text,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
