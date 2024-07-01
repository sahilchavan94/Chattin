import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 40,
              color: AppPallete.errorColor,
            ),
            verticalSpacing(5),
            Text(
              ToastMessages.defaultFailureMessage,
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
              ),
            ),
            verticalSpacing(4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                ToastMessages.defaultErrorMessage,
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.greyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
