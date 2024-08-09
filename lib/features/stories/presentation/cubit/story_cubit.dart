import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/features/upload/domain/usecases/general_upload.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:chattin/features/stories/domain/usecases/get_stories.dart';
import 'package:chattin/features/stories/domain/usecases/upload_story.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final UploadStoryUseCase _uploadStoryUseCase;
  final GeneralUploadUseCase _generalUploadUseCase;
  final GetStoriesUseCase _getStoriesUseCase;
  final FirebaseAuth _firebaseAuth;
  StoryCubit(
    this._uploadStoryUseCase,
    this._firebaseAuth,
    this._generalUploadUseCase,
    this._getStoriesUseCase,
  ) : super(StoryState.initial());

  //method to upload story
  Future<void> uploadStory({
    required String displayName,
    required String phoneNumber,
    required String imageUrl,
    required List<File> imageFiles,
    required List<String> captions,
  }) async {
    final List<Map<String, dynamic>> imageUrlList = [];
    final uid = _firebaseAuth.currentUser!.uid;
    //upload your images to firebase storage
    if (imageFiles.length > 5) {
      showToast(
        content: ToastMessages.storyUploadLimitFailure,
        type: ToastificationType.error,
      );
      return;
    }

    showToast(
      content: ToastMessages.storyInProgress,
      description: ToastMessages.storyNote,
      type: ToastificationType.info,
    );

    //upload the images and store the urls
    for (final image in imageFiles) {
      final storyId = const Uuid().v1();
      final uploadResponse = await _generalUploadUseCase.call(
        media: image,
        referencePath: 'stories/$uid/$storyId',
      );
      if (uploadResponse.isRight()) {
        final uploadedUrl = uploadResponse.getOrElse((l) => "");
        if (uploadedUrl.isNotEmpty) {
          imageUrlList.add({
            "url": uploadedUrl,
            "referencePath": 'stories/$uid/$storyId',
            "caption": captions[imageFiles.indexOf(image)],
          });
        } else {
          showToast(
            content: ToastMessages.defaultFailureMessage,
            description: ToastMessages.defaultFailureDescription,
            type: ToastificationType.error,
          );
          return;
        }
      }
    }

    //call the upload use case
    final response = await _uploadStoryUseCase.call(
      displayName: displayName,
      phoneNumber: phoneNumber,
      imageUrlList: imageUrlList,
      imageUrl: imageUrl,
      uid: uid,
    );

    response.fold(
      (l) {
        showToast(
          content: ToastMessages.defaultFailureMessage,
          description: ToastMessages.defaultFailureDescription,
          type: ToastificationType.error,
        );
      },
      (r) {
        showToast(
          content: ToastMessages.storyUploadSuccess,
          type: ToastificationType.success,
        );
      },
    );
  }

  //method to fetch all the stories from your contacts including yours
  Future<void> getStories({
    required List<String> phoneNumbers,
    required String selfNumber,
  }) async {
    emit(state.copyWith(storyStatus: StoryStatus.loading));
    final response = await _getStoriesUseCase.call(
      phoneNumbers: phoneNumbers,
    );
    response.fold(
      (l) {
        emit(
          state.copyWith(
            storyStatus: StoryStatus.failure,
          ),
        );
      },
      (r) {
        //get your own story from the fetched stories
        StoryEntity? myStory;
        for (var i = 0; i < r.length; i++) {
          if (r[i].phoneNumber == selfNumber) {
            myStory = r[i];
            r.removeAt(i);
            break;
          }
        }
        emit(state.copyWith(
          storyStatus: StoryStatus.success,
          stories: r,
          myStory: myStory,
        ));
      },
    );
  }
}
