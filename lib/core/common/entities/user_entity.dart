// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chattin/core/enum/enums.dart';

class UserEntity {
  final String uid;
  final String displayName;
  final String imageUrl;
  final String? email;
  final String? phoneNumber;
  final String? phoneCode;
  final String? about;
  final Status? status;
  final DateTime? joinedOn;
  UserEntity({
    required this.uid,
    required this.displayName,
    required this.imageUrl,
    required this.email,
    required this.phoneNumber,
    required this.phoneCode,
    required this.about,
    required this.joinedOn,
    required this.status,
  });
}
