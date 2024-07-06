// ignore_for_file: public_member_api_docs, sort_constructors_first

class ContactEntity {
  final String? uid;
  final String displayName;
  final String? about;
  final String imageUrl;
  final String? phoneNumber;
  //adding 2 extra fields just to resuse the model in case of showing the chat contacts on the home screen
  //not created another chat contact for fetching chat contacts added last message and time sent here only
  final String? lastMessage;
  final DateTime? timeSent;
  ContactEntity({
    required this.uid,
    this.phoneNumber,
    required this.displayName,
    required this.about,
    required this.imageUrl,
    this.lastMessage,
    this.timeSent,
  });
}
