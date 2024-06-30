import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/common/models/user_model.dart';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserEntity> getProfileData(String uid);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  const ProfileRemoteDataSourceImpl({required this.firebaseFirestore});

  //get the profile data
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
}
