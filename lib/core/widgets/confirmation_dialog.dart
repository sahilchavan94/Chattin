import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String description;
  final String approvalText;
  final String rejectionText;
  const DialogWidget({
    super.key,
    required this.onPressed,
    required this.approvalText,
    required this.rejectionText,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: AppPallete.bottomSheetColor,
      surfaceTintColor: AppPallete.bottomSheetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      content: SizedBox(
        width: (size.width) * .9,
        height: (size.height * .2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
              ),
            ),
            verticalSpacing(10),
            Text(
              description,
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(size.width * .06),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                  width: size.width * .2,
                  height: 40,
                  buttonText: approvalText,
                  onPressed: onPressed,
                ),
                ButtonWidget(
                  width: size.width * .2,
                  height: 40,
                  color: AppPallete.whiteColor,
                  textColor: AppPallete.backgroundColor,
                  buttonText: rejectionText,
                  onPressed: () {
                    context.pop();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
