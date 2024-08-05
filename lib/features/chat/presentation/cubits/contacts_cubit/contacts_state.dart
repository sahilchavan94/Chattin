// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'contacts_cubit.dart';

enum ContactsStatus {
  initial,
  loading,
  success,
  failure,
}

class ContactsState {
  ContactsStatus contactsStatus;
  List<ContactEntity>? contactList;
  String? message;

  ContactsState({
    required this.contactsStatus,
    this.contactList,
    this.message,
  });

  ContactsState.initial() : this(contactsStatus: ContactsStatus.initial);

  ContactsState copyWith({
    ContactsStatus? contactsStatus,
    List<ContactEntity>? contactList,
    String? message,
  }) {
    return ContactsState(
      contactsStatus: contactsStatus ?? this.contactsStatus,
      contactList: contactList ?? this.contactList,
      message: message ?? this.message,
    );
  }
}
