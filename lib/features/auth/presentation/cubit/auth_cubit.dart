// ignore: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/auth/domain/usecases/check_status.dart';
import 'package:chattin/features/auth/domain/usecases/email_auth.dart';
import 'package:chattin/features/auth/domain/usecases/email_verification.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CreateAccountWithEmailAndPasswordUseCase
      _createAccountWithEmailAndPasswordUseCase;
  final SendEmailVerificationLinkUseCase _sendEmailVerificationLinkUseCase;
  final CheckVerificationStatusUseCase _checkVerificationStatusUseCase;
  AuthCubit(
    this._createAccountWithEmailAndPasswordUseCase,
    this._sendEmailVerificationLinkUseCase,
    this._checkVerificationStatusUseCase,
  ) : super(AuthState.initial());

  //method for sending otp
  Future<void> createAccountWithEmailAndPassword(
      String email, String password) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final response = await _createAccountWithEmailAndPasswordUseCase.call(
      email,
      password,
    );
    response.fold(
      (l) {
        showToast(
          content: '${l.message}',
          description:
              'Server responded with an unexpected error, please try again',
          type: ToastificationType.error,
        );
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
          ),
        );
      },
      (r) {
        showToast(
          content: r,
          type: ToastificationType.success,
        );
        Constants.navigatorKey.currentContext!.pushReplacement(
          RoutePath.verifyEmail.path,
        );
        emit(
          state.copyWith(
            authStatus: AuthStatus.success,
          ),
        );
      },
    );
  }

  //method for email verification
  Future<void> sendEmailVerificationLink() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final response = await _sendEmailVerificationLinkUseCase.call();
    response.fold(
      (l) {
        showToast(
          content: '${l.message}',
          description:
              'Server responded with an unexpected error, please try again',
          type: ToastificationType.error,
        );
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
          ),
        );
      },
      (r) {
        if (r.isEmpty) {
          showToast(
            content: "Email already verified",
            type: ToastificationType.success,
          );

          return;
        }
        showToast(
          content: r,
          type: ToastificationType.success,
        );
        Constants.navigatorKey.currentContext!.pushReplacement(
          RoutePath.checkVerification.path,
        );
        emit(
          state.copyWith(
            authStatus: AuthStatus.success,
          ),
        );
      },
    );
  }

  //check the verification status
  Future<void> checkVerificationStatus() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final response = await _checkVerificationStatusUseCase.call();
    response.fold(
      (l) {
        showToast(
          content: '${l.message}',
          description:
              'Server responded with an unexpected error, please try again',
          type: ToastificationType.error,
        );
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
          ),
        );
      },
      (r) {
        if (r.isNotEmpty) {
          showToast(
            content: r,
            type: ToastificationType.success,
          );
          emit(
            state.copyWith(
              authStatus: AuthStatus.success,
            ),
          );
          return;
        }
        showToast(
          content: "Email not verified",
          description:
              "The email you added is not verified yet. Email verification is needed to continue with further process",
          type: ToastificationType.error,
        );
      },
    );
  }
}
