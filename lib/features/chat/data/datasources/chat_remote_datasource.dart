import 'package:chattin/core/common/models/user_model.dart';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/features/chat/data/models/contact_model.dart';
import 'package:chattin/features/chat/data/models/message_model.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<ContactEntity>> getAppContacts(List<String> phoneNumbers);
  Future<String> sendTextMessage({
    required String text,
    required String recieverId,
    required UserModel sender,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  ChatRemoteDataSourceImpl({required this.firebaseFirestore});

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
  }) async {
    //create a message model representing a single message
    final MessageModel message = MessageModel(
      senderId: sender.uid,
      receiverId: receiver!.uid,
      text: text,
      timeSent: timeSent,
      messageId: messageId,
      status: false,
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
      for (String phoneNumber in phoneNumbers) {
        final response = await firebaseFirestore
            .collection(Constants.userCollection)
            .where("phoneNumber", isEqualTo: phoneNumber)
            .get();

        if (response.docs.isNotEmpty) {
          appContacts.add(
            ContactModel.fromMap(
              response.docs.first.data(),
            ),
          );
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
      var messageId = const Uuid().v1();
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
      );
      return "";
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }
}
