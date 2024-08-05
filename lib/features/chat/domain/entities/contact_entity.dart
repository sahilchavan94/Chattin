// ignore_for_file: public_member_api_docs, sort_constructors_first
//adding 2 extra fields just to reuse the model in case of showing the chat contacts on the home screen
//not created another chat contact for fetching chat contacts added last message and time sent here only
class ContactEntity {
  final String imageUrl;
  final String displayName;
  final String? uid;
  final String? about;
  final String? phoneNumber;
  final String? lastMessage;
  final DateTime? timeSent;
  ContactEntity({
    this.timeSent,
    this.phoneNumber,
    this.lastMessage,
    required this.uid,
    required this.displayName,
    required this.about,
    required this.imageUrl,
  });
}
