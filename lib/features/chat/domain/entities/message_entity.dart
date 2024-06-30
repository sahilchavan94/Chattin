class MessageEntity {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime? timeSent;
  final String messageId;
  final bool status;

  MessageEntity({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timeSent,
    required this.messageId,
    required this.status,
  });
}
