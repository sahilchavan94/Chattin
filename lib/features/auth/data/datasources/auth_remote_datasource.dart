// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> sendOtpOnPhone(String phoneNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
  });

  @override
  Future<String> sendOtpOnPhone(String phoneNumber) async {
    try {
      String id = '';
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (e) {
          throw ServerException(error: e.toString());
        },
        codeSent: ((String verificationId, int? resendToken) async {
          id = verificationId;
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      if (id.isEmpty) {
        throw const ServerException(error: "Failed to send the otp");
      }
      return id;
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }
}
