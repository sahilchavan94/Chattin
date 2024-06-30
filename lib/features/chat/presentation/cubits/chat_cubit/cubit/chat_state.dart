part of 'chat_cubit.dart';

enum ChatStatus {
  initial,
  loading,
  success,
  failure,
}

class ChatState {
  ChatStatus chatStatus;

  String? message;
  ChatState({
    required this.chatStatus,
    this.message,
  });

  ChatState.initial() : this(chatStatus: ChatStatus.initial);

  ChatState copyWith({
    ChatStatus? chatStatus,
    String? message,
  }) {
    return ChatState(
      chatStatus: chatStatus ?? this.chatStatus,
      message: message ?? this.message,
    );
  }
}
