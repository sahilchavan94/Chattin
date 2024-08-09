// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    super.repliedTo,
    super.repliedToType,
    required super.senderId,
    required super.receiverId,
    required super.text,
    required super.timeSent,
    required super.messageId,
    required super.status,
    required super.messageType,
    required super.isReply,
    required super.isForwarded,
  });

  Map<String, dynamic> toMap() {
    //if the message is a replied message then -> add required fields
    // ( isReply,repliedTo,repliedToType )
    if (isReply) {
      return <String, dynamic>{
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'timeSent': timeSent!.millisecondsSinceEpoch,
        'messageId': messageId,
        'status': status,
        'messageType': messageType.convertMessageTypeToString(),
        'repliedTo': repliedTo,
        'repliedToType': repliedToType!.convertMessageTypeToString(),
        'isReply': true,
      };
    }
    if (isForwarded) {
      return <String, dynamic>{
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'timeSent': timeSent!.millisecondsSinceEpoch,
        'messageId': messageId,
        'status': status,
        'messageType': messageType.convertMessageTypeToString(),
        'isForwarded': true,
      };
    }
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timeSent': timeSent!.millisecondsSinceEpoch,
      'messageId': messageId,
      'status': status,
      'messageType': messageType.convertMessageTypeToString(),
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
      status: map['status'] ??
          false, //status here resembles to seen/unseen status of message
      messageType: map['messageType'] != null
          ? (map['messageType'] as String).convertStringToMessageType()
          : MessageType.text,
      isReply: map['isReply'] ?? false, //whether the message is a reply
      repliedTo: map['repliedTo'] != null
          ? map['repliedTo'] as String
          : "", //to which message this message is replied to
      repliedToType: map['repliedToType'] != null
          ? (map['repliedToType'] as String).convertStringToMessageType()
          : MessageType
              .text, //the type of the message to which this message is replied
      isForwarded: map['isForwarded'] ?? false,
    );
  }
}
