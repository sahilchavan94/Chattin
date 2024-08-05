part of 'chat_cubit.dart';

//for handling the state of chat contacts
enum ChatStatus {
  initial,
  loading,
  success,
  failure,
}

//for handling the chat stream ( chats between two users )
enum ChatStreamStatus {
  loading,
  success,
  failure,
}

//for handling the online/offline status of a user
enum ChatOnOffStreamStatus {
  loading,
  success,
  failure,
}

//for handling the other user's profile information
enum ChatContactInformationStatus {
  loading,
  success,
  failure,
}

class ChatState {
  ChatStatus chatStatus;
  ChatStreamStatus? chatStreamStatus;
  ChatOnOffStreamStatus? chatOnOffStreamStatus;
  ChatContactInformationStatus? chatContactInformationStatus;
  UserEntity? chatContactInformation;
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
    this.chatContactInformation,
    this.chatStreamStatus,
    this.chatOnOffStreamStatus,
    this.chatContactInformationStatus,
    this.message,
  });

  ChatState.initial() : this(chatStatus: ChatStatus.initial);

  ChatState copyWith({
    ChatStatus? chatStatus,
    ChatStreamStatus? chatStreamStatus,
    ChatOnOffStreamStatus? chatOnOffStreamStatus,
    ChatContactInformationStatus? chatContactInformationStatus,
    UserEntity? chatContactInformation,
    List<ContactEntity>? chatContacts,
    List<MessageEntity>? currentChatMessages,
    Status? currentChatStatus,
    String? message,
    bool? sendingMessage,
  }) {
    return ChatState(
      chatStatus: chatStatus ?? this.chatStatus,
      chatStreamStatus: chatStreamStatus ?? this.chatStreamStatus,
      chatOnOffStreamStatus:
          chatOnOffStreamStatus ?? this.chatOnOffStreamStatus,
      chatContactInformationStatus:
          chatContactInformationStatus ?? this.chatContactInformationStatus,
      chatContactInformation:
          chatContactInformation ?? this.chatContactInformation,
      chatContacts: chatContacts ?? this.chatContacts,
      currentChatMessages: currentChatMessages ?? this.currentChatMessages,
      message: message ?? this.message,
      sendingMessage: sendingMessage ?? this.sendingMessage,
      currentChatStatus: currentChatStatus ?? this.currentChatStatus,
    );
  }
}
