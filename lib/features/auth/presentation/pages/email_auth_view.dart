import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/dialog_box.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(100),
            Row(
              children: [
                Text(
                  "Chattin",
                  style:
                      AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                    color: AppPallete.blueColor,
                  ),
                ),
                Text(
                  "`",
                  style:
                      AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                    color: AppPallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                horizontalSpacing(5),
                Image.asset(
                  'assets/images/logo.png',
                  width: 28,
                ),
              ],
            ),
            Text(
              "Get started easily with 3 simple steps 😌",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
                fontSize: 14,
              ),
            ),
            verticalSpacing(46),
            InputWidget(
              labelText: 'Email',
              textEditingController: _emailController,
              hintText: "Enter your email",
              onSuffixIconPressed: () {
                if (_emailController.text.trim().isEmpty) {
                  showToast(
                    content: 'Email can\'t be empty',
                    type: ToastificationType.error,
                  );
                  return;
                }
              },
              suffixIcon: const Icon(
                Icons.email,
              ),
            ),
            verticalSpacing(12),
            InputWidget(
              labelText: 'Password',
              textEditingController: _passwordController,
              hintText: "Enter your password",
              suffixIcon: const Icon(
                Icons.lock,
              ),
            ),
            verticalSpacing(20),
            ButtonWidget(
              buttonText: 'Continue',
              isLoading: context.watch<AuthCubit>().state.authStatus ==
                  AuthStatus.loading,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogWidget(
                      onPressed: () {
                        context.pop();
                        context
                            .read<AuthCubit>()
                            .createAccountWithEmailAndPassword(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                      },
                      title: 'Recheck Title',
                      approvalText: 'Continue',
                      rejectionText: 'Cancel',
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
