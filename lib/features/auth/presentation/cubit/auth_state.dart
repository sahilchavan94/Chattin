// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  failure,
}

enum AuthWorkingStatus {
  loading,
  failure,
  success,
}

class AuthState {
  AuthStatus authStatus;
  AuthWorkingStatus? authWorkingStatus;
  String? message;
  AuthState({
    required this.authStatus,
    this.authWorkingStatus,
    this.message,
  });

  AuthState.initial() : this(authStatus: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? authStatus,
    AuthWorkingStatus? authWorkingStatus,
    String? message,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      authWorkingStatus: authWorkingStatus ?? this.authWorkingStatus,
      message: message ?? this.message,
    );
  }
}
