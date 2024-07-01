// ignore: depend_on_referenced_packages

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/features/upload/domain/usecases/general_upload.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/auth/domain/usecases/check_account_details.dart';
import 'package:chattin/features/auth/domain/usecases/check_status.dart';
import 'package:chattin/features/auth/domain/usecases/email_auth.dart';
import 'package:chattin/features/auth/domain/usecases/email_verification.dart';
import 'package:chattin/features/auth/domain/usecases/set_account_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CreateAccountWithEmailAndPasswordUseCase
      _createAccountWithEmailAndPasswordUseCase;
  final SendEmailVerificationLinkUseCase _sendEmailVerificationLinkUseCase;
  final CheckVerificationStatusUseCase _checkVerificationStatusUseCase;
  final CheckTheAccountDetailsIfTheEmailIsVerifiedUseCase
      _checkTheAccountDetailsIfTheEmailIsVerifiedUseCase;
  final SetAccountDetailsUseCase _setAccountDetailsUseCase;
  final GeneralUploadUseCase _generalUploadUseCase;
  final FirebaseAuth _firebaseAuth;
  AuthCubit(
    this._createAccountWithEmailAndPasswordUseCase,
    this._sendEmailVerificationLinkUseCase,
    this._checkVerificationStatusUseCase,
    this._setAccountDetailsUseCase,
    this._generalUploadUseCase,
    this._firebaseAuth,
    this._checkTheAccountDetailsIfTheEmailIsVerifiedUseCase,
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
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
          ),
        );
        showToast(
          content: l.message ?? ToastMessages.defaultFailureMessage,
          description: ToastMessages.defaultFailureDescription,
          type: ToastificationType.error,
        );
      },
      (r) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.success,
          ),
        );
        Constants.navigatorKey.currentContext!.pushReplacement(
          RoutePath.verifyEmail.path,
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
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
          ),
        );
        showToast(
          content: l.message ?? ToastMessages.defaultFailureMessage,
          description: ToastMessages.defaultFailureDescription,
          type: ToastificationType.error,
        );
      },
      (r) {
        if (r.isEmpty) {
          emit(
            state.copyWith(
              authStatus: AuthStatus.success,
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            authStatus: AuthStatus.success,
          ),
        );
        Constants.navigatorKey.currentContext!.pushReplacement(
          RoutePath.checkVerification.path,
        );
        showToast(
          content: r,
          type: ToastificationType.success,
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
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
          ),
        );
        showToast(
          content: l.message ?? ToastMessages.defaultFailureMessage,
          description: ToastMessages.defaultFailureDescription,
          type: ToastificationType.error,
        );
      },
      (r) {
        if (r.isNotEmpty) {
          emit(
            state.copyWith(
              authStatus: AuthStatus.success,
            ),
          );
          Constants.navigatorKey.currentContext!.pushReplacement(
            RoutePath.chatContacts.path,
          );

          return;
        }
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
          ),
        );
        showToast(
          content: ToastMessages.emailNotVerified,
          description: ToastMessages.emailNotVerifiedDescription,
          type: ToastificationType.error,
        );
      },
    );
  }

  //method for setting the account details
  Future<void> setAccountDetails({
    required String displayName,
    required String phoneNumber,
    required String phoneCode,
    required File imageFile,
  }) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    final response = await _generalUploadUseCase.call(
      imageFile,
      _firebaseAuth.currentUser!.uid,
    );

    if (response.isRight()) {
      final String imageUrl = response.getRight().getOrElse(() => "");
      if (imageUrl.isEmpty) {
        emit(state.copyWith(authStatus: AuthStatus.failure));
        showToast(
          content: ToastMessages.defaultFailureMessage,
          description: ToastMessages.defaultFailureDescription,
          type: ToastificationType.success,
        );

        return;
      }
      final authResponse = await _setAccountDetailsUseCase.call(
        displayName: displayName,
        phoneNumber: phoneNumber,
        phoneCode: phoneCode,
        imageUrl: imageUrl,
      );
      authResponse.fold(
        (l) {
          emit(state.copyWith(authStatus: AuthStatus.failure));

          showToast(
            content: l.message ?? ToastMessages.defaultFailureMessage,
            description: ToastMessages.defaultFailureDescription,
            type: ToastificationType.success,
          );
        },
        (r) {
          emit(state.copyWith(authStatus: AuthStatus.success));
          Constants.navigatorKey.currentContext!.pushReplacement(
            RoutePath.chatContacts.path,
          );
          showToast(
            content: r,
            type: ToastificationType.success,
          );
        },
      );
    }
  }

  //function to check whether the account is previously created or not
  Future<void> checkTheAccountDetailsIfTheEmailIsVerified() async {
    emit(
      state.copyWith(
        authStatus: AuthStatus.loading,
      ),
    );
    final response =
        await _checkTheAccountDetailsIfTheEmailIsVerifiedUseCase.call();
    response.fold(
      (l) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
          ),
        );
        //only navigate to profile creation page if the data is not added by the user
        Constants.navigatorKey.currentContext!.pushReplacement(
          RoutePath.createProfile.path,
        );
        showToast(
          content: ToastMessages.completeProfileMessage,
          description: ToastMessages.completeProfileDescription,
          type: ToastificationType.error,
        );
      },
      (r) {
        //no need to do anything here
        emit(
          state.copyWith(
            authStatus: AuthStatus.success,
          ),
        );
      },
    );
  }
}
