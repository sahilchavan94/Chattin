import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_dialog.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  final String uid;
  final String imageUrl;
  final String displayName;
  final String? about;
  final String? status;
  final double? radius;
  final bool? hasVerticalSpacing;
  final bool? isViewingStory;
  final Color? titleColor;
  final Color? subTitleColor;
  const ContactWidget({
    super.key,
    required this.imageUrl,
    required this.uid,
    required this.displayName,
    this.about,
    this.hasVerticalSpacing,
    this.isViewingStory,
    this.radius,
    this.status,
    this.titleColor,
    this.subTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  if (isViewingStory != null && isViewingStory == true) {
                    return;
                  }
                  showImageDialog(
                    uid: uid,
                    context: context,
                    displayName: displayName,
                    imageUrl: imageUrl,
                  );
                },
                child: ImageWidget(
                  imagePath: imageUrl,
                  width: radius ?? 60,
                  height: radius ?? 60,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(60),
                ),
              ),
              horizontalSpacing(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style:
                        AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                      color: titleColor ?? AppPallete.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  verticalSpacing(5),
                  if (about != null)
                    Text(
                      about!.isEmpty
                          ? "Hello everyone, I'm now on Chattin`!"
                          : about!,
                      style: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: subTitleColor ?? AppPallete.greyColor,
                      ),
                    ),
                  if (status != null)
                    Text(
                      status!,
                      style: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color:
                            (status!).convertStringToStatus() == Status.online
                                ? AppPallete.blueColor
                                : AppPallete.redColor,
                      ),
                    )
                ],
              )
            ],
          ),
          hasVerticalSpacing == true
              ? verticalSpacing(25)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
