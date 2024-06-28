import 'package:chattin/core/enum/enums.dart';

class HelperFunctions {
  static Status parseStatusType(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return Status.online;
      case 'offline':
        return Status.offline;
      default:
        return Status.unavailable;
    }
  }
}
