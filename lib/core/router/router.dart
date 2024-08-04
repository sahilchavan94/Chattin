import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/constants.dart';
import 'package:chattin/core/widgets/image_view.dart';
import 'package:chattin/core/widgets/send_image_widget.dart';
import 'package:chattin/features/auth/presentation/pages/account_settings_view.dart';
import 'package:chattin/features/auth/presentation/pages/check_verification_status.dart';
import 'package:chattin/features/auth/presentation/pages/create_profile_view.dart';
import 'package:chattin/features/auth/presentation/pages/email_auth_view.dart';
import 'package:chattin/features/auth/presentation/pages/email_pass_login_view.dart';
import 'package:chattin/features/auth/presentation/pages/verify_email_view.dart';
import 'package:chattin/features/chat/presentation/pages/add_contact_view.dart';
import 'package:chattin/features/chat/presentation/pages/chat_contact_information_view.dart';
import 'package:chattin/features/chat/presentation/pages/chat_view.dart';
import 'package:chattin/features/chat/presentation/pages/select_contacts_view.dart';
import 'package:chattin/features/profile/presentation/pages/edit_profile_view.dart';
import 'package:chattin/features/profile/presentation/pages/profile_view.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:chattin/features/stories/presentation/pages/story_preview.dart';
import 'package:chattin/features/stories/presentation/pages/story_contacts_view.dart';
import 'package:chattin/features/stories/presentation/pages/story_view.dart';
import 'package:chattin/init_dependencies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/pages/chat_contacts_view.dart';

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

class AppRouter {
  static final router = GoRouter(
    redirect: (context, state) {
      final isLoggedIn = serviceLocator<FirebaseAuth>().currentUser;
      final isGoingToVerify = state.fullPath == RoutePath.emailAuth.path;
      final isGoingToChatContacts =
          state.fullPath == RoutePath.chatContacts.path;
      final isGoingToEmailAuth = state.fullPath == RoutePath.emailAuth.path;
      final isGoingToEmailLoginAuth =
          state.fullPath == RoutePath.emailPassLogin.path;

      if (isLoggedIn == null) {
        if (isGoingToEmailAuth || isGoingToEmailLoginAuth) {
          return null; // Allow navigation to email auth and login pages
        }
        return RoutePath.emailPassLogin.path;
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
            child: const EmailAuthView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.emailPassLogin.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const EmailPassLoginView(),
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
        path: RoutePath.accountSettings.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const AccountSettingsView(),
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
      ),
      GoRoute(
        path: RoutePath.addContact.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const AddContactView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.chatScreen.path,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: ChatView(
              uid: data['uid'],
              displayName: data['displayName'],
              imageUrl: data['imageUrl'],
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePath.chatContactInformation.path,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: ChatContactInformationView(
              uid: data['uid'],
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePath.profileScreen.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const ProfileView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.editProfile.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const EditProfileView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.imagePreview.path,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: ImagePreview(
              file: data['file'],
              onPressed: data['onPressed'],
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePath.storyPreview.path,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: StoryPreView(
              selectedFiles: data['selectedFiles'],
              imageUrl: data['imageUrl'],
              displayName: data['displayName'],
              phoneNumber: data['phoneNumber'],
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePath.storyContactsView.path,
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const StoryContactsView(),
          );
        },
      ),
      GoRoute(
        path: RoutePath.storyView.path,
        pageBuilder: (context, state) {
          final storyList = state.extra as List<StoryEntity>;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: StorySeeView(
              storyList: storyList,
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePath.imageView.path,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: ProfileImageView(
              imageUrl: data['imageUrl'] as String,
              displayName: data['displayName'] as String,
              isAnImageFromChat: data['isAnImageFromChat'] as bool?,
            ),
          );
        },
      )
    ],
  );
}
