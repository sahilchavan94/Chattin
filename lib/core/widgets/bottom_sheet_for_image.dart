import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

showBottomSheetForPickingImage(
    BuildContext context, VoidCallback onClick1, VoidCallback onClick2) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    backgroundColor: AppPallete.bottomSheetColor,
    constraints: BoxConstraints.expand(
      height: MediaQuery.of(context).size.height * .3,
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Select profile picture",
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
              ),
            ),
            Text(
              "This profile picture will be visible to everyone for now ",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.whiteColor,
              ),
            ),
            verticalSpacing(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onClick1,
                  child: Image.asset(
                    'assets/images/cam.png',
                    width: 60,
                  ),
                ),
                horizontalSpacing(20),
                GestureDetector(
                  onTap: onClick2,
                  child: Image.asset(
                    'assets/images/gal.png',
                    width: 66,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
