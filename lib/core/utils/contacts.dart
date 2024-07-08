import 'package:flutter_contacts/flutter_contacts.dart';

class Contacts {
  static Future<List<String>> getContacts({required String? selfNumber}) async {
    try {
      List<String> phoneNumbers = [];
      List<Contact> contacts = await FlutterContacts.getContacts();

      // Get all contacts (fully fetched)
      contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      for (final contact in contacts) {
        String number = contact.phones.first.number.replaceAll(" ", "");
        if (number.length > 10) {
          number = number.substring(number.length - 10);
        }
        if (number == selfNumber) {
          continue;
        } else {
          phoneNumbers.add(number);
        }
      }
      return phoneNumbers;
    } catch (e) {
      return [];
    }
  }
}
