import 'package:chattin/core/router/route_name.dart';

class RoutePath {
  //initial
  static const RouteName splashScreen = RouteName(
    path: '/splash_screen',
  );

  //authentication paths
  static const RouteName emailAuth = RouteName(
    path: '/email_auth',
  );
  static const RouteName emailPassLogin = RouteName(
    path: '/email_pass_login',
  );
  static const RouteName verifyEmail = RouteName(
    path: '/verify_email',
  );
  static const RouteName checkVerification = RouteName(
    path: '/check_status',
  );
  static const RouteName createProfile = RouteName(
    path: '/create_profile',
  );
  static const RouteName accountSettings = RouteName(
    path: '/account_settings',
  );
  static const RouteName deleteAccount = RouteName(
    path: '/delete_account',
  );

  //chat path ( main features )
  static const RouteName chatContacts = RouteName(
    path: "/chat_contacts",
  );
  static const RouteName selectContact = RouteName(
    path: "/select_contact",
  );
  static const RouteName addContact = RouteName(
    path: "/add_contact",
  );
  static const RouteName chatScreen = RouteName(
    path: "/chat_screen",
  );
  static const RouteName chatContactInformation = RouteName(
    path: "/chat_contact_information",
  );
  static const RouteName forwardChat = RouteName(
    path: "/forward_chat",
  );

  //profile path
  static const RouteName profileScreen = RouteName(
    path: "/user_profile",
  );
  static const RouteName editProfile = RouteName(
    path: "/edit_profile",
  );

  //image view
  static const RouteName imageView = RouteName(
    path: "/image_view",
  );
  static const RouteName imagePreview = RouteName(
    path: "/image_preview",
  );

  //story
  static const RouteName storyContactsView = RouteName(
    path: "/story_contacts_view",
  );
  static const RouteName storyPreview = RouteName(
    path: "/story_preview",
  );
  static const RouteName storyView = RouteName(
    path: "/story_view",
  );
}
