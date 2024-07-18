part of 'chat_cubit.dart';

enum ChatStatus {
  initial,
  loading,
  success,
  failure,
  chatFailure,
  profileInformationFailure,
}

class ChatState {
  ChatStatus chatStatus;
  UserEntity? chatContactInformation;
  List<ContactEntity>? chatContacts;
  List<MessageEntity>? currentChatMessages;
  Status? currentChatStatus;
  bool? sendingMessage;
  String? message;
  bool? fetchingUserInfo = false;

  ChatState({
    required this.chatStatus,
    this.chatContacts,
    this.currentChatMessages,
    this.sendingMessage,
    this.currentChatStatus,
    this.chatContactInformation,
    this.fetchingUserInfo,
    this.message,
  });

  ChatState.initial() : this(chatStatus: ChatStatus.initial);

  ChatState copyWith({
    ChatStatus? chatStatus,
    UserEntity? chatContactInformation,
    List<ContactEntity>? chatContacts,
    List<MessageEntity>? currentChatMessages,
    Status? currentChatStatus,
    String? message,
    bool? sendingMessage,
    bool? fetchingUserInfo,
  }) {
    return ChatState(
      chatStatus: chatStatus ?? this.chatStatus,
      chatContactInformation:
          chatContactInformation ?? this.chatContactInformation,
      chatContacts: chatContacts ?? this.chatContacts,
      currentChatMessages: currentChatMessages ?? this.currentChatMessages,
      message: message ?? this.message,
      sendingMessage: sendingMessage ?? this.sendingMessage,
      currentChatStatus: currentChatStatus ?? this.currentChatStatus,
      fetchingUserInfo: fetchingUserInfo ?? this.fetchingUserInfo,
    );
  }
}
