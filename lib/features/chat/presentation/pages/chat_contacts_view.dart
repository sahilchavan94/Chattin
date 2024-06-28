import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class ChatContactsView extends StatefulWidget {
  const ChatContactsView({super.key});

  @override
  State<ChatContactsView> createState() => _ChatContactsViewState();
}

class _ChatContactsViewState extends State<ChatContactsView> {
  @override
  void initState() {
    context.read<AuthCubit>().checkTheAccountDetailsIfTheEmailIsVerified();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.authStatus == AuthStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: GestureDetector(
              onTap: () {
                showToast(
                  content: 'Hello I am a toast message',
                  // description:
                  //     'This message is a dummy message just for testing the toast appearance ',
                  type: ToastificationType.success,
                );
              },
              child: Text(
                "Home Page",
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.whiteColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
