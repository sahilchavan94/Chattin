import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
                fontSize: 16,
              ),
            ),
            icon != null
                ? IconButton(
                    onPressed: () {
                      context.push(RoutePath.editProfile.path);
                    },
                    icon: icon!,
                    iconSize: 19,
                  )
                : const SizedBox.shrink(),
          ],
        ),
        verticalSpacing(25),
        userInfo(
          'Display Name',
          const Icon(
            Icons.person,
            color: AppPallete.greyColor,
            size: 20,
          ),
          Text(
            userData.displayName,
            style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
              color: AppPallete.whiteColor,
            ),
          ),
        ),
        userInfo(
          'Email',
          const Icon(
            Icons.email,
            color: AppPallete.greyColor,
            size: 20,
          ),
          Text(
            userData.email!,
            style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
              color: AppPallete.whiteColor,
            ),
          ),
        ),
        userInfo(
          'Phone no',
          const Icon(
            Icons.phone,
            color: AppPallete.greyColor,
            size: 20,
          ),
          Text(
            "+${userData.phoneCode!}${userData.phoneNumber!}",
            style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
              color: AppPallete.whiteColor,
            ),
          ),
        ),
        userInfo(
          'About',
          const Icon(
            Icons.info,
            color: AppPallete.greyColor,
            size: 20,
          ),
          Text(
            userData.about!,
            style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
              color: AppPallete.whiteColor,
            ),
          ),
        ),
        userInfo(
          'Joined on',
          const Icon(
            Icons.calendar_month,
            color: AppPallete.greyColor,
            size: 20,
          ),
          Text(
            DateFormat("dd MMM yyyy").format(userData.joinedOn!),
            style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
              color: AppPallete.whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}
