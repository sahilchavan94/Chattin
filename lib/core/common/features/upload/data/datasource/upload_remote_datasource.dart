import 'dart:io';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class UploadRemoteDataSource {
  Future<String> generalUpload(File media, String id);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final FirebaseStorage firebaseStorage;

  UploadRemoteDataSourceImpl({
    required this.firebaseStorage,
  });
  @override
  Future<String> generalUpload(File media, String path) async {
    final ref = firebaseStorage.ref().child(path);

    try {
      final response = await ref.putFile(media);
      return await response.ref.getDownloadURL();
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }
}
