// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/enum/enums.dart';

class MessageEntity {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime? timeSent;
  final String messageId;
  final bool status;
  final MessageType messageType;
  final bool isReply;
  final String? repliedTo;
  final MessageType? repliedToType;

  MessageEntity({
    required this.senderId,
    required this.isReply,
    this.repliedTo,
    required this.receiverId,
    required this.text,
    required this.timeSent,
    required this.messageId,
    required this.status,
    required this.messageType,
    this.repliedToType,
  });
}
