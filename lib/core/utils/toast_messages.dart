class ToastMessages {
  //auth cubit
  static const String defaultFailureMessage = "Something went wrong";
  static const String defaultFailureDescription =
      "Server responded with an unexpected error, please try again";
  static const String emailNotVerified = "Email not verified";
  static const String emailAlreadyVerified = "Email already verified";
  static const String emailNotVerifiedDescription =
      "The email you added is not verified yet. Email verification is needed to continue with further process";

  static const String completeProfileMessage = "Complete your profile";
  static const String completeProfileDescription =
      "Fill out the fields and complete your profile before proceeding further";

  //auth remote datasource
  static const String accountCreatedSuccessfully =
      "Account created successfully";
  static const String sentEmailVerficationMail =
      "Sent verification link to your email";
  static const String emailVerificationSuccessful =
      "Email verification successful";
  static const String welcomeSignInMessage =
      "Successfully saved! Welcome to Chattin`!";

  //chat cubit
  static const String chatContactsFailureMessage =
      "Something went wrong while fetching the contacts";

  //profile cubit
  static const String profileFailure =
      "Something unexpected happened while fetching the profile data";
}
