import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:chattin/features/stories/domain/repositories/stories_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetStoriesUseCase {
  final StoriesRepository storiesRepository;

  GetStoriesUseCase({required this.storiesRepository});

  Future<Either<Failure, List<StoryEntity>>> call({
    required List<String> phoneNumbers,
  }) async {
    return await storiesRepository.getStories(
      phoneNumbers: phoneNumbers,
    );
  }
}
