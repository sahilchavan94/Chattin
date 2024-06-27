// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:chattin/core/errors/exceptions.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> createAccountWithEmailAndPassword(
    String email,
    String password,
  );
  Future<String> sendEmailVerificationLink();
  Future<String> checkVerificationStatus();
  Future<String> setAccountDetails({
    required String displayName,
    required String phoneNumber,
    required String phoneCode,
    required String imageUrl,
  });
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
      return "Account created successfully";
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> sendEmailVerificationLink() async {
    try {
      if (firebaseAuth.currentUser!.emailVerified) {
        return "";
      }
      await firebaseAuth.currentUser?.sendEmailVerification();
      return "Sent verification link to your email";
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<String> checkVerificationStatus() async {
    try {
      firebaseAuth.currentUser!.reload();
      if (firebaseAuth.currentUser!.emailVerified) {
        return "Email verified successfully";
      }
      return "";
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
      await firebaseFirestore
          .collection(Constants.userCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        "displayName": displayName,
        "email": firebaseAuth.currentUser!.email,
        "phoneNumber": phoneNumber,
        "phoneCode": phoneCode,
        "imageUrl": imageUrl,
      });
      return "Account details set successfully";
    } catch (e) {
      log("firestore error is ${e.toString()}");
      throw ServerException(error: e.toString());
    }
  }
}
