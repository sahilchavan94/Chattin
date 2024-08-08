import 'package:flutter_contacts/flutter_contacts.dart';

class Requests {
  static Future<bool> requestContactsPermission() async {
    final permission = await FlutterContacts.requestPermission(readonly: false);
    return permission;
  }
}
