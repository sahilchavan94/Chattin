import 'dart:developer';

import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/features/stories/data/models/story_model.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class StoriesRemoteDataSource {
  Future<void> uploadStory({
    required String displayName,
    required String phoneNumber,
    required String imageUrl,
    required List imageUrlList,
    required String uid,
  });

  Future<List<StoryEntity>> getStories({
    required List<String> phoneNumbers,
  });
}

class StoriesRemoteDataSourceImpl implements StoriesRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  StoriesRemoteDataSourceImpl({required this.firebaseFirestore});
  @override
  Future<void> uploadStory({
    required String displayName,
    required String phoneNumber,
    required String imageUrl,
    required List imageUrlList,
    required String uid,
  }) async {
    try {
      final StoryModel story = StoryModel(
        displayName: displayName,
        phoneNumber: phoneNumber,
        imageUrlList: imageUrlList,
        imageUrl: imageUrl,
        uid: uid,
      );
      //get the stautus which is previously uploaded
      final previousStatus = await firebaseFirestore
          .collection(Constants.storyCollection)
          .doc(uid)
          .get();
      if (previousStatus.exists) {
        await firebaseFirestore
            .collection(Constants.storyCollection)
            .doc(uid)
            .update(story.toMap());
      } else {
        await firebaseFirestore
            .collection(Constants.storyCollection)
            .doc(uid)
            .set(story.toMap());
      }
    } catch (e) {
      log(e.toString());
      throw ServerException(
        error: e.toString(),
      );
    }
  }

  @override
  Future<List<StoryEntity>> getStories({
    required List<String> phoneNumbers,
  }) async {
    try {
      final List<StoryEntity> contactsStories = [];
      const int chunkSize = 5;
      final now = DateTime.now();
      final yesterday =
          now.subtract(const Duration(hours: 24)).millisecondsSinceEpoch;

      for (int i = 0; i < phoneNumbers.length; i += chunkSize) {
        final List<String> chunk = phoneNumbers.sublist(
          i,
          i + chunkSize > phoneNumbers.length
              ? phoneNumbers.length
              : i + chunkSize,
        );

        final response = await firebaseFirestore
            .collection(Constants.storyCollection)
            .where(
              "phoneNumber",
              whereIn: chunk,
            )
            .get();

        if (response.docs.isNotEmpty) {
          for (final doc in response.docs) {
            final data = doc.data();
            final imageUrlList = (data['imageUrlList'] as List)
                .where((image) => image['uploadedAt'] >= yesterday)
                .toList();
            if (imageUrlList.isNotEmpty) {
              data['imageUrlList'] = imageUrlList;
              contactsStories.add(StoryModel.fromMap(data));
            }
          }
        }
      }
      return contactsStories;
    } catch (e) {
      throw ServerException(
        error: e.toString(),
      );
    }
  }
}
