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
part 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final UploadStoryUseCase _uploadStoryUseCase;
  final GeneralUploadUseCase _generalUploadUseCase;
  final GetStoriesUseCase _getStoriesUseCase;
  final FirebaseAuth _firebaseAuth;
  StoriesCubit(
    this._uploadStoryUseCase,
    this._firebaseAuth,
    this._generalUploadUseCase,
    this._getStoriesUseCase,
  ) : super(StoriesState.initial());

  //method to upload story
  Future<void> uploadStory({
    required String displayName,
    required String phoneNumber,
    required List<File> imageFiles,
    required List<String> captions,
  }) async {
    final List<Map<String, dynamic>> imageUrlList = [];
    final uid = _firebaseAuth.currentUser!.uid;
    //upload your images to firebase storage
    if (imageFiles.length > 3) {
      showToast(
        content: ToastMessages.storyUploadLimitFailure,
        type: ToastificationType.error,
      );
      return;
    }

    showToast(
      content: ToastMessages.storyInProgress,
      type: ToastificationType.info,
    );

    //upload the images and store the urls
    for (final image in imageFiles) {
      final storyId = const Uuid().v1();
      final uploadResponse =
          await _generalUploadUseCase.call(image, 'stories/$uid/$storyId');
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
      uid: uid,
    );

    response.fold(
      (l) {
        showToast(
          content: l.message ?? ToastMessages.defaultFailureDescription,
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
  Future<void> getStories({required List<String> phoneNumbers}) async {
    emit(state.copyWith(storiesStatus: StoriesStatus.loading));
    final response = await _getStoriesUseCase.call(
      phoneNumbers: phoneNumbers,
    );
    response.fold(
      (l) {
        emit(
          state.copyWith(
            storiesStatus: StoriesStatus.failure,
          ),
        );
      },
      (r) {
        emit(state.copyWith(
          storiesStatus: StoriesStatus.success,
          stories: r,
        ));
      },
    );
  }
}
