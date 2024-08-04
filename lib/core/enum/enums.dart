enum Status {
  online,
  offline,
  unavailable,
}

extension StatusExtension on Status {
  String toStringValue() {
    switch (this) {
      case Status.online:
        return 'Online';
      case Status.offline:
        return 'Offline';
      case Status.unavailable:
        return 'Unavailable';
      default:
        return 'Unavailable';
    }
  }
}

enum MessageType {
  text('text'),
  image('image'),
  deleted('deleted');

  const MessageType(this.type);
  final String type;
}

extension MessageTypeExtension on MessageType {
  String toStringValue() {
    switch (this) {
      case MessageType.image:
        return '📸 Photo';
      case MessageType.text:
        return '💬 Text';
      case MessageType.deleted:
        return '🗑️ Deleted';
      default:
        return 'Unavailable';
    }
  }
}

extension ConvertToMessageType on String {
  MessageType toStringValue() {
    switch (this) {
      case '📸 Photo':
        return MessageType.image;
      case '💬 Text':
        return MessageType.text;
      case '🗑️ Deleted':
        return MessageType.deleted;

      default:
        return MessageType.text;
    }
  }
}
