// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/enum/enums.dart';

class MessageEntity {
  final String? repliedTo;
  final DateTime? timeSent;
  final MessageType? repliedToType;
  final bool isReply;
  final String text;
  final bool status;
  final String senderId;
  final String receiverId;
  final String messageId;
  final MessageType messageType;

  MessageEntity({
    this.repliedTo,
    this.repliedToType,
    required this.senderId,
    required this.isReply,
    required this.receiverId,
    required this.text,
    required this.timeSent,
    required this.messageId,
    required this.status,
    required this.messageType,
  });
}
