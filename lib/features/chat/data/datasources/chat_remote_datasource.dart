import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/features/chat/data/models/contact_model.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<ContactEntity>> getAppContacts(List<String> phoneNumbers);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  ChatRemoteDataSourceImpl({required this.firebaseFirestore});

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
}
