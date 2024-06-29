import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/features/auth/presentation/pages/check_verification_status.dart';
import 'package:chattin/features/auth/presentation/pages/create_profile_view.dart';
import 'package:chattin/features/auth/presentation/pages/email_auth_view.dart';
import 'package:chattin/features/auth/presentation/pages/verify_email_view.dart';
import 'package:chattin/features/chat/presentation/pages/chat_contacts_view.dart';
import 'package:chattin/features/chat/presentation/pages/select_contacts_view.dart';
import 'package:chattin/init_dependencies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage buildPageWithSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

class MyRouter {
  static final router = GoRouter(
    redirect: (context, state) {
      final isLoggedIn = serviceLocator<FirebaseAuth>().currentUser;
      final isGoingToVerify = state.fullPath == RoutePath.emailAuth.path;
      final isGoingToChatContacts =
          state.fullPath == RoutePath.chatContacts.path;
      if (isLoggedIn == null) {
        return RoutePath.emailAuth.path;
      } else if (!isLoggedIn.emailVerified && isGoingToVerify) {
        return RoutePath.verifyEmail.path;
      } else if (!isLoggedIn.emailVerified && isGoingToChatContacts) {
        return RoutePath.verifyEmail.path;
      } else {
        return null;
      }
    },
    initialLocation: RoutePath.chatContacts.path,
    navigatorKey: Constants.navigatorKey,
    routes: [
      GoRoute(
        path: RoutePath.emailAuth.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const PhoneAuthView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.verifyEmail.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const VerifyOtpView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.checkVerification.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const CheckVerificationView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.createProfile.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const CreateProfileView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.chatContacts.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const ChatContactsView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.selectContact.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const SelectContactsView(),
          );
        },
      )
    ],
  );
}
