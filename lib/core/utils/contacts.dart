import 'package:flutter_contacts/flutter_contacts.dart';

class Contacts {
  static Future<List<String>> getContacts({required String? selfNumber}) async {
    final persimission = await FlutterContacts.requestPermission();
    if (persimission) {
      try {
        List<String> phoneNumbers = [];
        List<Contact> contacts = await FlutterContacts.getContacts();

        // Get all contacts (fully fetched)
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );

        for (final contact in contacts) {
          final number = contact.phones.first.number.replaceAll(" ", "");
          if (number == selfNumber) {
            continue;
          }
          if (number.length > 10) {
            phoneNumbers.add(number.substring(number.length - 10));
          } else {
            phoneNumbers.add(number);
          }
        }
        return phoneNumbers;
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }
}
