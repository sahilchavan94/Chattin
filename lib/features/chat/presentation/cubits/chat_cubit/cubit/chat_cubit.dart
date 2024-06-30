import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/features/chat/domain/usecases/send_message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  ChatCubit(this.sendMessageUseCase) : super(ChatState.initial());

  //method to send a chat message
  Future<void> sendMessage({
    required String text,
    required String recieverId,
    required UserEntity sender,
  }) async {
    final response = await sendMessageUseCase.call(
      text: text,
      recieverId: recieverId,
      sender: sender,
    );
    response.fold(
      (l) {
        log("failed to send message");
      },
      (r) {
        log("message sent");
      },
    );
  }
}
