import 'package:chattin/core/router/route_name.dart';

class RoutePath {
  //authentication paths
  static const RouteName emailAuth = RouteName(
    path: '/email_auth',
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

  //chat path ( main features )
  static const RouteName chatContacts = RouteName(
    path: "/chat_contacts",
  );
  static const RouteName selectContact = RouteName(
    path: "/select_contact",
  );
}
