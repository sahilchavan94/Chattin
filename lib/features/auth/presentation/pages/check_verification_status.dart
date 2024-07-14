import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckVerificationView extends StatefulWidget {
  const CheckVerificationView({super.key});

  @override
  State<CheckVerificationView> createState() => _ChackVerificationViewState();
}

class _ChackVerificationViewState extends State<CheckVerificationView> {
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
              "Check verification status",
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
              ),
            ),
            verticalSpacing(5),

            Text(
              "A link is sent to your email. Click it to verify your email",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.whiteColor,
              ),
            ),
            verticalSpacing(5),
            Text(
              "Confirm verification status of your email to continue with further account creating procedure",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(76),
            Image.asset(
              'assets/images/check.png',
              width: 75,
            ),
            verticalSpacing(76),
            ButtonWidget(
              buttonText: 'Check Verification Status',
              isLoading: context.watch<AuthCubit>().state.authStatus ==
                  AuthStatus.loading,
              onPressed: () {
                context.read<AuthCubit>().checkVerificationStatus();
              },
            ),
            verticalSpacing(30),
            GestureDetector(
              onTap: () {
                context.read<AuthCubit>().sendEmailVerificationLink();
              },
              child: Text(
                "Resend email",
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.blueColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppPallete.blueColor,
                  fontSize: 14,
                ),
              ),
            ),
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
