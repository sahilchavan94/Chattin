// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  //for creating a new account in authentication
  Future<String> createAccountWithEmailAndPassword(
    String email,
    String password,
  );
  //for sending the email verfication link
  Future<String> sendEmailVerificationLink();
  //for checking the email verification status
  Future<String> checkVerificationStatus();
  //storing the user details in the database
  Future<String> setAccountDetails({
    required String displayName,
    required String phoneNumber,
    required String phoneCode,
    required String imageUrl,
  });
  //for routing the user to appropriate page
  Future<String> checkTheAccountDetailsIfTheEmailIsVerified();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<String> createAccountWithEmailAndPassword(
      String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ToastMessages.accountCreatedSuccessfully;
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> sendEmailVerificationLink() async {
    final currentUser = firebaseAuth.currentUser;
    try {
      if (currentUser == null) {
        throw const ServerException();
      }
      if (currentUser.emailVerified) {
        return "";
      }
      await firebaseAuth.currentUser?.sendEmailVerification();
      return ToastMessages.sentEmailVerficationMail;
    } on FirebaseException catch (e) {
      throw ServerException(
        error: e.toString().split("] ")[1],
      );
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> checkVerificationStatus() async {
    final currentUser = firebaseAuth.currentUser;
    try {
      if (currentUser == null) {
        throw const ServerException();
      }
      currentUser.reload();
      if (currentUser.emailVerified) {
        return ToastMessages.emailVerificationSuccessful;
      }
      return "";
    } on FirebaseException catch (e) {
      throw ServerException(
        error: e.toString().split("] ")[1],
      );
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> setAccountDetails({
    required String displayName,
    required String phoneNumber,
    required String phoneCode,
    required String imageUrl,
  }) async {
    try {
      final email = firebaseAuth.currentUser!.email;
      final uid = firebaseAuth.currentUser!.uid;
      await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(uid)
          .set({
        "uid": uid,
        "displayName": displayName,
        "email": email,
        "phoneNumber": phoneNumber,
        "phoneCode": phoneCode,
        "imageUrl": imageUrl,
        "status": Status.online.toStringValue(),
      });
      return ToastMessages.welcomeSignInMessage;
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> checkTheAccountDetailsIfTheEmailIsVerified() async {
    try {
      final uid = firebaseAuth.currentUser!.uid;
      final response = await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(uid)
          .get();

      //if the user data not exists, this means the user is logged in but sign up process is still not done

      if (response.exists) {
        return "";
      }
      throw const ServerException();
    } catch (e) {
      throw ServerException(
        error: e.toString(),
      );
    }
  }
}
