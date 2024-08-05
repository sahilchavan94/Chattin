import 'dart:developer';

import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/firebase_format.dart';
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
        phoneNumber: phoneNumber,
        imageUrlList: imageUrlList,
        uid: uid,
      );

      //get the stautus which is previously uploaded
      final previousStatus = await firebaseFirestore
          .collection(Constants.storyCollection)
          .doc(uid)
          .get();

      //if the user has any previous stories uploaded
      //in that case update the previous stories by adding new stories
      if (previousStatus.exists) {
        await firebaseFirestore
            .collection(Constants.storyCollection)
            .doc(uid)
            .update(story.toMap());
        return;
      }

      //if the user doesn't have any stories added prevously
      //then add the new stories directly
      await firebaseFirestore
          .collection(Constants.storyCollection)
          .doc(uid)
          .set(story.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        error: FirebaseResponseFormat.firebaseFormatError(e.toString()),
      );
    } catch (e) {
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
        //search for 5 contacts at a time
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

            //filter the images from the imageUrlList where the uploaded date
            //is older than yesterday
            final imageUrlList = (data['imageUrlList'] as List)
                .where((image) => image['uploadedAt'] >= yesterday)
                .toList();

            //get the user's data
            //this is done to ensure that if the user updates their details
            //in that case their updated details can be displayed
            //in order to avoid this issues whatsApp displays the name stored in the native devices
            //but for now we are not doing it

            final userData = await firebaseFirestore
                .collection(Constants.userCollection)
                .doc(data['uid'])
                .get();

            //update the field 'userEntity' in data as the user's current details
            if (userData.exists) {
              data['userEntity'] = userData.data();
            }

            //also update the filtered imageUrlList and add it in the contactStories
            if (imageUrlList.isNotEmpty) {
              data['imageUrlList'] = imageUrlList;
              contactsStories.add(StoryModel.fromMap(data));
            }
          }
        }
      }

      return contactsStories;
    } on FirebaseException catch (e) {
      throw ServerException(
        error: FirebaseResponseFormat.firebaseFormatError(e.toString()),
      );
    } catch (e) {
      log(e.toString());
      throw ServerException(
        error: e.toString(),
      );
    }
  }
}
