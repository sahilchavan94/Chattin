class ToastMessages {
  //auth cubit
  static const String defaultFailureMessage = "Something went wrong";
  static String defaultErrorMessage =
      'An unexpected error occurred. Please try again later. You can send a message to us for reporting the issue';

  static const String defaultFailureDescription =
      "Something unexpected happened out of nowhere, please try again";
  static const String emailNotVerified = "Email not verified";
  static const String emailAlreadyVerified = "Email already verified";
  static const String emailNotVerifiedDescription =
      "The email you added is not verified yet. Email verification is needed to continue with further process";

  static const String completeProfileMessage = "Complete your profile";
  static const String completeProfileDescription =
      "Fill out the fields and complete your profile before proceeding further";
  static const String phoneMessage =
      "Please ensure that the phone number entered belongs to you and is in a valid format. For now there is no mechanism to verify phone number so please don't use any other's number";

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
