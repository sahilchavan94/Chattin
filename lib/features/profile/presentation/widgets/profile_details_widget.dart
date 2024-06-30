import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileDetailsWidget extends StatelessWidget {
  final String title;
  final Icon? icon;
  final UserEntity userData;
  const ProfileDetailsWidget({
    super.key,
    required this.title,
    this.icon,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.whiteColor,
              ),
            ),
            icon != null
                ? IconButton(onPressed: () {}, icon: icon!)
                : const SizedBox.shrink(),
          ],
        ),
        verticalSpacing(25),
        userInfo(
          'Display Name',
          userData.displayName,
          const Icon(
            Icons.person,
            color: AppPallete.greyColor,
          ),
          null,
        ),
        userInfo(
          'Email',
          userData.email!,
          const Icon(
            Icons.email,
            color: AppPallete.greyColor,
          ),
          null,
        ),
        userInfo(
          'Phone no',
          userData.phoneCode!,
          const Icon(
            Icons.phone,
            color: AppPallete.greyColor,
          ),
          null,
        ),
        userInfo(
          'About',
          userData.about!,
          const Icon(
            Icons.info,
            color: AppPallete.greyColor,
          ),
          null,
        ),
        userInfo(
          'Joined on',
          '24 Oct 2023',
          const Icon(
            Icons.calendar_month,
            color: AppPallete.greyColor,
          ),
          null,
        ),
      ],
    );
  }
}

Widget userInfo(String title, String value, Icon icon, Icon? suffix) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              horizontalSpacing(10),
              Text(
                title,
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.greyColor,
                ),
              )
            ],
          ),
          suffix ??
              Text(
                value,
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.whiteColor,
                ),
              )
        ],
      ),
      verticalSpacing(20)
    ],
  );
}
