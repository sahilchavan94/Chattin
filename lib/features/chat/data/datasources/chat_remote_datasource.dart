import 'dart:developer';

import 'package:chattin/core/common/models/user_model.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/helper_functions.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/features/chat/data/models/contact_model.dart';
import 'package:chattin/features/chat/data/models/message_model.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<ContactEntity>> getAppContacts(List<String> phoneNumbers);
  Future<String> sendTextMessage({
    required String text,
    required String recieverId,
    required UserModel sender,
  });
  Future<String> sendFileMessage({
    required String downloadedUrl,
    required String recieverId,
    required String messageId,
    required UserModel sender,
    required MessageType messageType,
  });
  Stream<List<MessageEntity>> getChatStream({
    required String recieverId,
    required String senderId,
  });
  Stream<List<ContactEntity>> getChatContacts(String uid);
  Stream<Status> getChatStatus(String uid);
  Future<void> setChatStatus({
    required Status status,
    required String uid,
  });
  Future<void> setMessageStatus({
    required String receiverUserId,
    required String messageId,
    required String senderId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  ChatRemoteDataSourceImpl({
    required this.firebaseFirestore,
  });

  _saveDataToContactsSubcollection({
    required UserModel sender,
    required UserModel? receiver,
    required String text,
    required DateTime timeSent,
  }) async {
    //create a chat contact for the receiver
    final receiverChatContact = ContactModel(
      uid: sender.uid,
      displayName: sender.displayName,
      imageUrl: sender.imageUrl,
      timeSent: timeSent,
      lastMessage: text,
    );

    //create a chat contact for the sender
    final senderChatContact = ContactModel(
      uid: receiver!.uid,
      displayName: receiver.displayName,
      imageUrl: receiver.imageUrl,
      timeSent: timeSent,
      lastMessage: text,
    );

    //add in the reciver's doc inside the chat sub collection, a doc with the sender's id
    await firebaseFirestore
        .collection(Constants.userCollection)
        .doc(receiver.uid)
        .collection(Constants.chatsSubCollection)
        .doc(sender.uid)
        .set(
          receiverChatContact.toMap(),
        );
    //same for the sender's doc
    await firebaseFirestore
        .collection(Constants.userCollection)
        .doc(sender.uid)
        .collection(Constants.chatsSubCollection)
        .doc(receiver.uid)
        .set(
          senderChatContact.toMap(),
        );
  }

  _saveMessageToMessageSubcollection({
    required UserModel sender,
    required UserModel? receiver,
    required String text,
    required String messageId,
    required DateTime timeSent,
    required MessageType messageType,
  }) async {
    //create a message model representing a single message
    final MessageModel message = MessageModel(
      senderId: sender.uid,
      receiverId: receiver!.uid,
      text: text,
      timeSent: timeSent,
      messageId: messageId,
      status: false,
      messageType: messageType,
    );

    //store the message in both sender's and receiver's chats

    //sender's document
    await firebaseFirestore
        .collection(Constants.userCollection)
        .doc(sender.uid)
        .collection(Constants.chatsSubCollection)
        .doc(receiver.uid)
        .collection(Constants.messagesSubCollection)
        .doc(messageId)
        .set(
          message.toMap(),
        );

    //receiver's document
    await firebaseFirestore
        .collection(Constants.userCollection)
        .doc(receiver.uid)
        .collection(Constants.chatsSubCollection)
        .doc(sender.uid)
        .collection(Constants.messagesSubCollection)
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  @override
  Future<List<ContactEntity>> getAppContacts(List<String> phoneNumbers) async {
    try {
      final List<ContactEntity> appContacts = [];
      const int chunkSize = 10;
      for (int i = 0; i < phoneNumbers.length; i += chunkSize) {
        final List<String> chunk = phoneNumbers.sublist(
          i,
          i + chunkSize > phoneNumbers.length
              ? phoneNumbers.length
              : i + chunkSize,
        );

        final response = await firebaseFirestore
            .collection(Constants.userCollection)
            .where(
              "phoneNumber",
              whereIn: chunk,
            )
            .get();

        if (response.docs.isNotEmpty) {
          for (final doc in response.docs) {
            appContacts.add(ContactModel.fromMap(doc.data()));
          }
        }
      }
      return appContacts;
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> sendTextMessage({
    required String text,
    required String recieverId,
    required UserModel sender,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();
      UserModel? receiver;

      //get the receiver's data
      final receiverData = await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(recieverId)
          .get();

      //set the receiver data
      receiver = UserModel.fromMap(
        receiverData.data()!,
      );

      //save the data to the contacts sub collection
      _saveDataToContactsSubcollection(
        sender: sender,
        receiver: receiver,
        text: text,
        timeSent: timeSent,
      );

      //save the message in sender and the receiver's collection
      _saveMessageToMessageSubcollection(
        sender: sender,
        receiver: receiver,
        text: text,
        messageId: messageId,
        timeSent: timeSent,
        messageType: MessageType.text,
      );
      return ToastMessages.welcomeSignInMessage; //change it later
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> sendFileMessage({
    required String downloadedUrl,
    required String recieverId,
    required String messageId,
    required UserModel sender,
    required MessageType messageType,
  }) async {
    try {
      final timeSent = DateTime.now();

      UserModel? receiver;

      //get the receiver's data
      final receiverData = await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(recieverId)
          .get();

      //set the receiver data
      receiver = UserModel.fromMap(
        receiverData.data()!,
      );

      final String msgTypeString = messageType.toStringValue();

      _saveDataToContactsSubcollection(
        sender: sender,
        receiver: receiver,
        text: msgTypeString,
        timeSent: timeSent,
      );

      _saveMessageToMessageSubcollection(
        sender: sender,
        receiver: receiver,
        text: downloadedUrl,
        messageId: messageId,
        timeSent: timeSent,
        messageType: MessageType.image,
      );
      return ToastMessages.welcomeSignInMessage; //change it later
    } catch (e) {
      throw ServerException(
        error: e.toString(),
      );
    }
  }

  @override
  Stream<List<MessageEntity>> getChatStream({
    required String recieverId,
    required String senderId,
  }) {
    final response = firebaseFirestore
        .collection(Constants.userCollection)
        .doc(senderId)
        .collection(Constants.chatsSubCollection)
        .doc(recieverId)
        .collection(Constants.messagesSubCollection)
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (final document in event.docs) {
        messages.add(
          MessageModel.fromMap(
            document.data(),
          ),
        );
      }
      return messages;
    });
    return response;
  }

  @override
  Stream<List<ContactEntity>> getChatContacts(String uid) {
    final response = firebaseFirestore
        .collection(Constants.userCollection)
        .doc(uid)
        .collection(Constants.chatsSubCollection)
        .snapshots()
        .asyncMap((event) {
      List<ContactEntity> contacts = [];
      for (final document in event.docs) {
        contacts.add(
          ContactModel.fromMap(
            document.data(),
          ),
        );
      }
      return contacts;
    });
    return response;
  }

  @override
  Stream<Status> getChatStatus(String uid) {
    final response = firebaseFirestore
        .collection(Constants.userCollection)
        .doc(uid)
        .snapshots()
        .asyncMap(
      (event) {
        final data = event.data();
        if (data == null) {
          return Status.unavailable;
        }
        return HelperFunctions.parseStatusType(
          data['status'] as String,
        );
      },
    );

    return response;
  }

  @override
  Future<void> setChatStatus({
    required Status status,
    required String uid,
  }) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(uid)
          .update(
        {
          'status': status.toStringValue(),
        },
      );
    } catch (e) {
      throw ServerException(
        error: e.toString(),
      );
    }
  }

  @override
  Future<void> setMessageStatus({
    required String receiverUserId,
    required String messageId,
    required String senderId,
  }) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(senderId)
          .collection(Constants.chatsSubCollection)
          .doc(receiverUserId)
          .collection(Constants.messagesSubCollection)
          .doc(messageId)
          .update(
        {'status': true},
      );
    } catch (e) {
      throw ServerException(
        error: e.toString(),
      );
    }
  }
}
