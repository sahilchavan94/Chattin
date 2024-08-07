class ToastMessages {
  //auth cubit
  static const String defaultFailureMessage = "Something went wrong";
  static const String reauthenticatedUserSuccess = "Verified successfully";
  static const String reauthenticatedUserFailure = "Verification failed";
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
  static const String signedInSuccessfully = "Signed in successfully";
  static const String sentEmailVerficationMail =
      "Sent verification link to your email";
  static const String emailVerificationSuccessful =
      "Email verification successful";
  static const String welcomeSignInMessage =
      "Successfully saved! Welcome to Chattin`!";
  static const String signedOutSuccessfully = "Signed out successfully";
  static const String deletedAccountSuccessfully =
      "Account deleted successfully";

  //chat presentation
  static const String forwardLimitReached =
      "Cannot forward to more than 5 chats";
  static const String forwardingMessages =
      "Forwarding messages to selected contacts";
  static const String forwardMessageSuccess = "Message forwarded successfully";
  static const String noContactsSelected =
      "Select atleast 1 contact to forward";
  static const String forwardMessageFailure = "Failed to forward your message";

  //chat cubit
  static const String chatContactsFailureMessage =
      "Something went wrong while fetching the contacts";
  static const String failedToSentLastMessage =
      "Failed to send the last message";

  //chat remote data source
  static const String messageDeleteForMeSuccess = "Message deleted for you";
  static const String messageDeleteForMeSuccessDesc =
      "This message is only deleted for you, the receiver can still view it from their side";
  static const String messageDeleteEveryoneSuccess =
      "Message deleted for everyone";
  static const String newContactAdded = "New contact added successfully";
  static const String deletedMessage = "This message is deleted by the sender";

  //profile cubit
  static const String profileFailure =
      "Something unexpected happened while fetching the profile data";
  static const String updateProfileSuccess = "Profile updated successfully";

  //stories cubit
  static const String storyUploadLimitFailure =
      "You can't choose more than 5 images";
  static const String storyUploadSuccess = "Successfully added story";
  static const String storyInProgress = "Uploading your stories";
  static const String storyNote = "Your stories will be visible soon";

  //image downloading
  static const String imageDownload = "Image downloaded successfully!";
}
