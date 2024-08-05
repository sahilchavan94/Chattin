import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/common/models/user_model.dart';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserEntity> getProfileData(
    String uid,
  );

  Future<String> setProfileData({
    required String uid,
    required String displayName,
    required String phoneNumber,
    required String about,
  });

  Future<String> setProfileImage({
    required String uid,
    required String imageUrl,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  const ProfileRemoteDataSourceImpl({required this.firebaseFirestore});

  @override
  Future<UserEntity> getProfileData(String uid) async {
    try {
      final response = await firebaseFirestore
          .collection(Constants.userCollection)
          .where("uid", isEqualTo: uid)
          .get();

      return UserModel.fromMap(
        response.docs.first.data(),
      );
    } catch (e) {
      throw ServerException(
        error: e.toString(),
      );
    }
  }

  @override
  Future<String> setProfileData({
    required String uid,
    required String displayName,
    required String phoneNumber,
    required String about,
  }) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(uid)
          .update({
        "displayName": displayName,
        "phoneNumber": phoneNumber,
        "about": about,
      });
      return ToastMessages.updateProfileSuccess;
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> setProfileImage({
    required String uid,
    required String imageUrl,
  }) async {
    try {
      await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(uid)
          .update(
        {"imageUrl": imageUrl},
      );
      return ToastMessages.updateProfileSuccess;
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }
}
