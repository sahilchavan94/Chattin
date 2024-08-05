import 'package:chattin/core/enum/enums.dart';
import 'package:flutter/material.dart';

class ReplyMessageProvider extends ChangeNotifier {
  MessageType messageType = MessageType.text; //type of the message
  bool isReplyWidgetOpened =
      false; //flag to set whether to show the reply widget or not
  bool isMe = false; //whether you are replying to self message
  String repliedTo = ""; //the message to which you are replying
  String senderName = ""; //sender of the message to which we are replying
  String senderImageUrl = ""; //sender profile image url
  String senderId = ""; //sender id
  String receiverId = ""; //receiver id
  String currentReplyChatId = ""; //the user to which you are replying

  void setReplyParams({
    required MessageType type,
    required String message,
    required String messageSender,
    required String messageSenderImage,
    required String sId,
    required String rId,
    required bool isMeP,
    required String currentChat,
  }) {
    isReplyWidgetOpened = true;
    messageType = type;
    repliedTo = message;
    senderName = messageSender;
    senderImageUrl = messageSenderImage;
    senderId = sId;
    receiverId = rId;
    isMe = isMeP;
    currentReplyChatId = currentChat;
    notifyListeners();
  }

  void clearReplyData() {
    messageType = MessageType.text;
    repliedTo = "";
    senderName = "";
    isMe = false;
    receiverId = "";
    senderId = "";
    senderImageUrl = "";
    isReplyWidgetOpened = false;
    notifyListeners();
  }
}
