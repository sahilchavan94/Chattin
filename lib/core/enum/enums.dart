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
