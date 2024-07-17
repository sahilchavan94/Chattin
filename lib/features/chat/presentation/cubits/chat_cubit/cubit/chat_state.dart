part of 'chat_cubit.dart';

enum ChatStatus {
  initial,
  loading,
  success,
  failure,
}

class ChatState {
  ChatStatus chatStatus;
  List<ContactEntity>? chatContacts;
  List<MessageEntity>? currentChatMessages;
  Status? currentChatStatus;
  bool? sendingMessage;
  String? message;
  ChatState({
    required this.chatStatus,
    this.chatContacts,
    this.currentChatMessages,
    this.sendingMessage,
    this.currentChatStatus,
    this.message,
  });

  ChatState.initial() : this(chatStatus: ChatStatus.initial);

  ChatState copyWith({
    ChatStatus? chatStatus,
    List<ContactEntity>? chatContacts,
    List<MessageEntity>? currentChatMessages,
    Status? currentChatStatus,
    String? message,
    bool? sendingMessage,
  }) {
    return ChatState(
      chatStatus: chatStatus ?? this.chatStatus,
      chatContacts: chatContacts ?? this.chatContacts,
      currentChatMessages: currentChatMessages ?? this.currentChatMessages,
      message: message ?? this.message,
      sendingMessage: sendingMessage ?? this.sendingMessage,
      currentChatStatus: currentChatStatus ?? this.currentChatStatus,
    );
  }
}
