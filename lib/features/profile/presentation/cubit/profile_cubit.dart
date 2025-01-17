import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/common/features/upload/domain/usecases/general_upload.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/features/profile/domain/usecases/get_profile.dart';
import 'package:chattin/features/profile/domain/usecases/set_profile.dart';
import 'package:chattin/features/profile/domain/usecases/set_profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/utils/toasts.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  //usecases
  final GetProfileDataUseCase _getProfileDataUseCase;
  final SetProfileDataUseCase _setProfileDataUseCase;
  final SetProfileImageUseCase _setProfileImageUseCase;
  final GeneralUploadUseCase _generalUploadUseCase;
  final FirebaseAuth firebaseAuth;

  ProfileCubit(
    this._getProfileDataUseCase,
    this._setProfileDataUseCase,
    this.firebaseAuth,
    this._generalUploadUseCase,
    this._setProfileImageUseCase,
  ) : super(ProfileState.initial()) {
    //fetching the profile data as soon as the cubit is initialized
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      getProfileData();
    }
  }

  //method for getting the profile data
  Future<void> getProfileData() async {
    if (firebaseAuth.currentUser == null) {
      return;
    }

    emit(
      state.copyWith(
        profileStatus: ProfileStatus.loading,
      ),
    );

    final uid = firebaseAuth.currentUser!.uid;
    final response = await _getProfileDataUseCase.call(uid);

    response.fold(
      (l) {
        emit(
          state.copyWith(
            profileStatus: ProfileStatus.failure,
          ),
        );
        showToast(
          content: l.message ?? ToastMessages.defaultFailureMessage,
          description: ToastMessages.profileFailure,
          type: ToastificationType.error,
        );
      },
      (r) async {
        emit(
          state.copyWith(
            profileStatus: ProfileStatus.success,
            userData: r,
          ),
        );
      },
    );
  }

  //method for updating the profile data
  Future<void> setProfileData({
    required String displayName,
    required String phoneNumber,
    required String about,
  }) async {
    if (firebaseAuth.currentUser == null) {
      return;
    }

    emit(
      state.copyWith(
        setProfileStatus: SetProfileStatus.loading,
      ),
    );

    final uid = firebaseAuth.currentUser!.uid;
    Constants.navigatorKey.currentContext!.pop();

    final response = await _setProfileDataUseCase.call(
      uid: uid,
      about: about,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );

    response.fold(
      (l) {
        showToast(
          content: l.message ?? ToastMessages.defaultFailureMessage,
          description: ToastMessages.profileFailure,
          type: ToastificationType.error,
        );
      },
      (r) {
        showToast(
          content: ToastMessages.updateProfileSuccess,
          type: ToastificationType.success,
        );
        emit(
          state.copyWith(
            setProfileStatus: SetProfileStatus.success,
          ),
        );
        getProfileData();
      },
    );
  }

  //method for updating the profile image
  Future<void> setProfileImage({
    File? imageFile,
    bool? isRemoving,
  }) async {
    String imageUrl = "";
    final String uid = firebaseAuth.currentUser!.uid;

    emit(
      state.copyWith(
        setProfileImageStatus: SetProfileImageStatus.loading,
      ),
    );

    //if the user is not removing the profile
    //only in that case set the profile image as an empty string
    if (isRemoving != null && isRemoving == false) {
      final uploadResponse = await _generalUploadUseCase.call(
        media: imageFile!,
        referencePath: "profileImages/$uid",
      );
      if (uploadResponse.isRight()) {
        imageUrl = uploadResponse.getOrElse((l) => "");
      } else {
        showToast(
          content: ToastMessages.profileFailure,
          type: ToastificationType.error,
          description: ToastMessages.defaultFailureDescription,
        );
        return;
      }
    }

    final response = await _setProfileImageUseCase.call(
      uid: uid,
      imageUrl: imageUrl,
    );

    response.fold(
      (l) {
        showToast(
          content: ToastMessages.profileFailure,
          description: ToastMessages.defaultFailureDescription,
          type: ToastificationType.error,
        );
      },
      (r) {
        emit(
          state.copyWith(
            setProfileImageStatus: SetProfileImageStatus.success,
          ),
        );
        getProfileData();
      },
    );
  }
}
