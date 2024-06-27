// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  failure,
}

class AuthState {
  AuthStatus authStatus;
  String? message;
  AuthState({
    required this.authStatus,
    this.message,
  });

  AuthState.initial() : this(authStatus: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? authStatus,
    String? message,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      message: message ?? this.message,
    );
  }

  // @override
  // bool operator ==(covariant AuthState other) {
  //   if (identical(this, other)) return true;

  //   return other.authStatus == authStatus && other.message == message;
  // }

  // @override
  // int get hashCode => authStatus.hashCode ^ message.hashCode;
}
