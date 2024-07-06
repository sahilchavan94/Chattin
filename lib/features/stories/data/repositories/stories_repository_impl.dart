// ignore_for_file: void_checks

import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/features/stories/data/datasources/stories_remote_datasource.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:chattin/features/stories/domain/repositories/stories_repository.dart';
import 'package:fpdart/fpdart.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesRemoteDataSourceImpl storiesRemoteDataSourceImpl;

  StoriesRepositoryImpl({required this.storiesRemoteDataSourceImpl});
  @override
  Future<Either<Failure, void>> uploadStory({
    required String displayName,
    required String phoneNumber,
    required List imageUrlList,
    required String uid,
  }) async {
    try {
      final response = await storiesRemoteDataSourceImpl.uploadStory(
        displayName: displayName,
        phoneNumber: phoneNumber,
        imageUrlList: imageUrlList,
        uid: uid,
      );
      return Right(response);
    } catch (e) {
      return Left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> getStories({
    required List<String> phoneNumbers,
  }) async {
    try {
      final response = await storiesRemoteDataSourceImpl.getStories(
        phoneNumbers: phoneNumbers,
      );
      return Right(response);
    } catch (e) {
      return Left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
