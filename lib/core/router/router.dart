import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/features/auth/presentation/pages/phone_auth_view.dart';
import 'package:chattin/features/auth/presentation/pages/verify_otp_view.dart';
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
    initialLocation: RoutePath.phoneAuth.path,
    routes: [
      GoRoute(
        path: RoutePath.phoneAuth.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const PhoneAuthView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.verifyOtp.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const VerifyOtpView(),
          );
        },
      )
    ],
  );
}
