import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class StoriesRepository {
  Future<Either<Failure, void>> uploadStory({
    required String displayName,
    required String phoneNumber,
    required List imageUrlList,
    required String uid,
  });
  Future<Either<Failure, List<StoryEntity>>> getStories({
    required List<String> phoneNumbers,
  });
}
