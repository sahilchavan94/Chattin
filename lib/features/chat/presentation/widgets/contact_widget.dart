import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  final String imageUrl;
  final String displayName;
  final String about;
  const ContactWidget({
    super.key,
    required this.imageUrl,
    required this.displayName,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            ImageWidget(
              imagePath: imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(60),
            ),
            horizontalSpacing(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style:
                      AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                    color: AppPallete.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                verticalSpacing(5),
                Text(
                  about.isEmpty
                      ? "Hello everyone, I'm now on Chattin`!"
                      : about,
                  style:
                      AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                    color: AppPallete.greyColor,
                  ),
                )
              ],
            )
          ],
        ),
        verticalSpacing(25),
      ],
    );
  }
}
