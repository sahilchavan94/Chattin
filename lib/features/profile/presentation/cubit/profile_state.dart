// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

//for handling the profile data
enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
}

//for handling the profile data updating
enum SetProfileStatus {
  loading,
  success,
}

//for handling the profile image updating
enum SetProfileImageStatus {
  loading,
  success,
}

class ProfileState {
  ProfileStatus profileStatus;
  SetProfileStatus? setProfileStatus;
  SetProfileImageStatus? setProfileImageStatus;
  bool? isImageLoading;
  UserEntity? userData;
  String? message;

  ProfileState({
    this.message,
    this.userData,
    this.isImageLoading = false,
    this.setProfileStatus,
    this.setProfileImageStatus,
    required this.profileStatus,
  });

  ProfileState.initial() : this(profileStatus: ProfileStatus.initial);

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    SetProfileStatus? setProfileStatus,
    SetProfileImageStatus? setProfileImageStatus,
    UserEntity? userData,
    bool? isImageLoading,
    String? message,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      setProfileStatus: setProfileStatus ?? this.setProfileStatus,
      setProfileImageStatus:
          setProfileImageStatus ?? this.setProfileImageStatus,
      isImageLoading: isImageLoading ?? this.isImageLoading,
      userData: userData ?? this.userData,
      message: message ?? this.message,
    );
  }
}
