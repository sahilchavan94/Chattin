import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getIconWithTitle(
              Text(
                'Sign Out from current account',
                style: AppTheme.darkThemeData.textTheme.displayMedium!.copyWith(
                  color: AppPallete.blueColor,
                ),
              ),
              const Icon(
                Icons.logout_outlined,
                color: AppPallete.blueColor,
                size: 18,
                weight: 1,
              ),
            ),
            verticalSpacing(30),
            Text(
              "Dangerous area",
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.whiteColor,
                fontSize: 15,
              ),
            ),
            verticalSpacing(7),
            _getIconWithTitle(
              Text(
                'Delete your current account',
                style: AppTheme.darkThemeData.textTheme.displayMedium!.copyWith(
                  color: AppPallete.errorColor,
                ),
              ),
              const Icon(
                Icons.delete_outlined,
                color: AppPallete.errorColor,
                size: 18,
                weight: 1,
              ),
            ),
            verticalSpacing(5),
            Text(
              "Once your account is deleted you can't recover your account information, chats. Be sure before deleting it.",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _getIconWithTitle(
  Text title,
  Widget icon,
) {
  return Row(
    children: [
      title,
      horizontalSpacing(7.5),
      icon,
    ],
  );
}
