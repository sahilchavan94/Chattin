// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
}

enum UpdateProfileStatus {
  initial,
  loading,
  success,
  failure,
}

class ProfileState {
  ProfileStatus profileStatus;
  UpdateProfileStatus? updateProfileStatus;
  bool? isImageLoading;
  UserEntity? userData;
  String? message;
  ProfileState({
    required this.profileStatus,
    this.updateProfileStatus,
    this.userData,
    this.isImageLoading = false,
    this.message,
  });

  ProfileState.initial() : this(profileStatus: ProfileStatus.initial);

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UpdateProfileStatus? updateProfileStatus,
    UserEntity? userData,
    bool? isImageLoading,
    String? message,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
      isImageLoading: isImageLoading ?? this.isImageLoading,
      userData: userData ?? this.userData,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(covariant ProfileState other) {
    if (identical(this, other)) return true;

    return other.profileStatus == profileStatus &&
        other.updateProfileStatus == updateProfileStatus &&
        other.isImageLoading == isImageLoading &&
        other.userData == userData &&
        other.message == message;
  }

  @override
  int get hashCode {
    return profileStatus.hashCode ^
        updateProfileStatus.hashCode ^
        isImageLoading.hashCode ^
        userData.hashCode ^
        message.hashCode;
  }
}
