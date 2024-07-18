class FirebaseResponseFormat {
  static String firebaseFormatError(String message) {
    return message.toString().split("] ")[1];
  }
}
