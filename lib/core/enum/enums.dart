enum Status {
  online,
  offline,
  unavailable,
}

extension StatusExtension on Status {
  String convertStatusToString() {
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

extension ConvertToStatus on String {
  Status convertStringToStatus() {
    switch (this) {
      case 'Online':
        return Status.online;
      case 'Offline':
        return Status.offline;
      default:
        return Status.unavailable;
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
  String convertMessageTypeToString() {
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
  MessageType convertStringToMessageType() {
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
