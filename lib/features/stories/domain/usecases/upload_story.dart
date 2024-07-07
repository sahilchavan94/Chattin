import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/stories/domain/repositories/stories_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadStoryUseCase {
  final StoriesRepository storiesRepository;
  UploadStoryUseCase({
    required this.storiesRepository,
  });

  Future<Either<Failure, void>> call({
    required String displayName,
    required String phoneNumber,
    required List imageUrlList,
    required String imageUrl,
    required String uid,
  }) async {
    return await storiesRepository.uploadStory(
      displayName: displayName,
      phoneNumber: phoneNumber,
      imageUrlList: imageUrlList,
      imageUrl: imageUrl,
      uid: uid,
    );
  }
}
