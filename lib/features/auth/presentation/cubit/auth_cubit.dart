// ignore: depend_on_referenced_packages

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chattin/core/common/features/upload/domain/usecases/general_upload.dart';
import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/auth/domain/usecases/check_account_details.dart';
import 'package:chattin/features/auth/domain/usecases/check_status.dart';
import 'package:chattin/features/auth/domain/usecases/delete_account.dart';
import 'package:chattin/features/auth/domain/usecases/email_auth.dart';
import 'package:chattin/features/auth/domain/usecases/email_verification.dart';
import 'package:chattin/features/auth/domain/usecases/reauthenticate_user.dart';
import 'package:chattin/features/auth/domain/usecases/set_account_details.dart';
import 'package:chattin/features/auth/domain/usecases/sign_in.dart';
import 'package:chattin/features/auth/domain/usecases/sign_out.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CreateAccountWithEmailAndPasswordUseCase
      _createAccountWithEmailAndPasswordUseCase;
  final SignInUseCase _signInUseCase;
  final SendEmailVerificationLinkUseCase _sendEmailVerificationLinkUseCase;
  final CheckVerificationStatusUseCase _checkVerificationStatusUseCase;
  final CheckTheAccountDetailsIfTheEmailIsVerifiedUseCase
      _checkTheAccountDetailsIfTheEmailIsVerifiedUseCase;
  final SetAccountDetailsUseCase _setAccountDetailsUseCase;
  final GeneralUploadUseCase _generalUploadUseCase;
  final ReauthenticateUser _reauthenticateUser;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final SignOutUseCase _signOutUseCase;
  final FirebaseAuth _firebaseAuth;
  AuthCubit(
    this._createAccountWithEmailAndPasswordUseCase,
    this._sendEmailVerificationLinkUseCase,
    this._checkVerificationStatusUseCase,
    this._setAccountDetailsUseCase,
    this._generalUploadUseCase,
    this._firebaseAuth,
    this._checkTheAccountDetailsIfTheEmailIsVerifiedUseCase,
    this._signOutUseCase,
    this._deleteAccountUseCase,
    this._reauthenticateUser,
    this._signInUseCase,
  ) : super(AuthState.initial());

  //method for creating account
  Future<void> createAccountWithEmailAndPassword(
    String email,
    String password,
  ) async {
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

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final response = await _signInUseCase.call(
      email: email,
      password: password,
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
          RoutePath.chatContacts.path,
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
    required File? imageFile,
    bool toast = true,
  }) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    String imageUrl = "";
    Either<Failure, String> response;

    //if an image is selected by the user then upload it to firebase storage
    if (imageFile != null) {
      response = await _generalUploadUseCase.call(
        imageFile,
        "profileImages/${_firebaseAuth.currentUser!.uid}",
      );

      if (response.isRight()) {
        imageUrl = response.getRight().getOrElse(() => "");
        if (imageUrl.isEmpty) {
          emit(state.copyWith(authStatus: AuthStatus.failure));
          showToast(
            content: ToastMessages.defaultFailureMessage,
            description: ToastMessages.defaultFailureDescription,
            type: ToastificationType.success,
          );
          return;
        }
      }
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
        if (r.isEmpty) {
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
        }
        emit(
          state.copyWith(
            authStatus: AuthStatus.success,
          ),
        );
      },
    );
  }

  //method for reauthenticating user
  Future<void> reauthenticateUser({
    required String email,
    required String password,
    required VoidCallback callback,
  }) async {
    emit(
      state.copyWith(
        authStatus: AuthStatus.loading,
      ),
    );
    final response = await _reauthenticateUser.call(
      email: email,
      password: password,
    );
    response.fold((l) {
      showToast(
        content: ToastMessages.reauthenticatedUserFailure,
        type: ToastificationType.error,
      );
      emit(
        state.copyWith(
          authStatus: AuthStatus.failure,
        ),
      );
    }, (r) {
      showToast(
        content: ToastMessages.reauthenticatedUserSuccess,
        type: ToastificationType.success,
      );
      emit(
        state.copyWith(
          authStatus: AuthStatus.success,
        ),
      );
      callback();
    });
  }

  //method for signing out
  Future<void> signOut() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final response = await _signOutUseCase.call();
    response.fold(
      (l) {
        showToast(
          content: l.message ?? ToastMessages.defaultFailureMessage,
          description: ToastMessages.defaultFailureDescription,
          type: ToastificationType.error,
        );
      },
      (r) {
        showToast(
          content: r,
          type: ToastificationType.success,
        );
        // go removes all the other pages in the stack and goes to the specified route
        Constants.navigatorKey.currentContext!.go(
          RoutePath.emailPassLogin.path,
        );
        emit(
          state.copyWith(
            authStatus: AuthStatus.initial,
          ),
        );
      },
    );
  }

  //method to delete the account
  Future<void> deleteAccount(String uid) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    final response = await _deleteAccountUseCase.call(uid);
    response.fold((l) {
      showToast(
        content: ToastMessages.defaultFailureMessage,
        type: ToastificationType.error,
        description: ToastMessages.defaultFailureDescription,
      );
      emit(
        state.copyWith(
          authStatus: AuthStatus.failure,
        ),
      );
    }, (r) {
      showToast(
        content: ToastMessages.deletedAccountSuccessfully,
        type: ToastificationType.success,
      );
      Constants.navigatorKey.currentContext!.go(
        RoutePath.emailPassLogin.path,
      );
      emit(
        state.copyWith(
          authStatus: AuthStatus.success,
        ),
      );
    });
  }
}
