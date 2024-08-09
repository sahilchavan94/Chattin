import 'dart:io';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class UploadRemoteDataSource {
  Future<String> generalUpload({
    required File media,
    required String referencePath,
  });
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final FirebaseStorage firebaseStorage;

  UploadRemoteDataSourceImpl({
    required this.firebaseStorage,
  });
  @override
  Future<String> generalUpload({
    required File media,
    required String referencePath,
  }) async {
    final ref = firebaseStorage.ref().child(referencePath);

    try {
      final response = await ref.putFile(media);
      return await response.ref.getDownloadURL();
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }
}
