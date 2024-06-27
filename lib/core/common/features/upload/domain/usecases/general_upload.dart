import 'dart:io';

import 'package:chattin/core/common/features/upload/domain/repositories/upload_repository.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

class GeneralUploadUseCase {
  final UploadRepository uploadRepository;

  GeneralUploadUseCase({required this.uploadRepository});

  Future<Either<Failure, String>> call(File media, String id) async {
    return await uploadRepository.generalUpload(media, id);
  }
}
