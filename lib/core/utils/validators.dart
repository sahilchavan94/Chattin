class Validators {
  static String? validateEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      return 'Password must be at least 8 characters long, contain at least one letter, one number, and one special character';
    }
    return null;
  }

  static String? validateDisplayName(String displayName) {
    // Updated to check that display name is not only numbers and ensure valid length
    final displayNameRegex = RegExp(r'^(?!\d+$)[a-zA-Z0-9\s]{2,50}$');
    if (!displayNameRegex.hasMatch(displayName)) {
      return 'Display name must be between 2 and 50 characters and cannot be only numbers';
    }
    return null;
  }

  static String? validatePhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\d{10,15}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validatePhoneCode(String phoneCode) {
    final phoneCodeRegex = RegExp(r'^\d{1,4}$');
    if (!phoneCodeRegex.hasMatch(phoneCode)) {
      return 'Please enter a valid phone code';
    }
    return null;
  }
}
