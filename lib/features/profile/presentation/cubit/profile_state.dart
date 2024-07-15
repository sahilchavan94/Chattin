// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
}

class ProfileState {
  ProfileStatus profileStatus;
  bool? isImageLoading;
  UserEntity? userData;
  String? message;
  ProfileState({
    required this.profileStatus,
    this.userData,
    this.isImageLoading = false,
    this.message,
  });

  ProfileState.initial() : this(profileStatus: ProfileStatus.initial);

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserEntity? userData,
    bool? isImageLoading,
    String? message,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      isImageLoading: isImageLoading ?? this.isImageLoading,
      userData: userData ?? this.userData,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(covariant ProfileState other) {
    if (identical(this, other)) return true;

    return other.profileStatus == profileStatus &&
        other.isImageLoading == isImageLoading &&
        other.userData == userData &&
        other.message == message;
  }

  @override
  int get hashCode {
    return profileStatus.hashCode ^
        isImageLoading.hashCode ^
        userData.hashCode ^
        message.hashCode;
  }
}
