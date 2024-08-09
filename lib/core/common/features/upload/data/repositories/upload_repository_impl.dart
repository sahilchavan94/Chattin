import 'dart:io';

import 'package:chattin/core/common/features/upload/data/datasource/upload_remote_datasource.dart';
import 'package:chattin/core/common/features/upload/domain/repositories/upload_repository.dart';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSourceImpl uploadRemoteDataSourceImpl;

  UploadRepositoryImpl({required this.uploadRemoteDataSourceImpl});
  @override
  Future<Either<Failure, String>> generalUpload({
    required File media,
    required String referencePath,
  }) async {
    try {
      final response = await uploadRemoteDataSourceImpl.generalUpload(
        media: media,
        referencePath: referencePath,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        Failure(
          e.error,
        ),
      );
    }
  }
}
