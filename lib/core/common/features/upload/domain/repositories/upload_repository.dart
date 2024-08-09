import 'dart:io';

import 'package:chattin/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UploadRepository {
  Future<Either<Failure, String>> generalUpload({
    required File media,
    required String referencePath,
  });
}
