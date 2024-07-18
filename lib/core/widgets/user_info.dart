import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

Widget userInfo(
  String title,
  Icon icon,
  Widget value,
) {
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
          value,
        ],
      ),
      verticalSpacing(20)
    ],
  );
}
