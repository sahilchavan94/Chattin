import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyOtpView extends StatefulWidget {
  const VerifyOtpView({super.key});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalSpacing(20),
            Text(
              "Verify Email",
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
              ),
            ),
            verticalSpacing(5),
            Text(
              "We need you to verify your email to ensure secure access",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.whiteColor,
              ),
            ),
            verticalSpacing(5),
            Text(
              "Please make sure that the provided email is correct and in a valid format.The verification process will fail if the mail is incorrect",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(76),
            Image.asset(
              'assets/images/mail.png',
              width: 75,
            ),
            verticalSpacing(76),
            ButtonWidget(
              buttonText: 'Send mail to verify email',
              isLoading: context.watch<AuthCubit>().state.authStatus ==
                  AuthStatus.loading,
              onPressed: () {
                context.read<AuthCubit>().sendEmailVerificationLink();
              },
            ),
            verticalSpacing(12),

            // ButtonWidget(
            //   buttonText: 'Change Email',
            //   color: AppPallete.whiteColor,
            //   textColor: AppPallete.backgroundColor,
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
