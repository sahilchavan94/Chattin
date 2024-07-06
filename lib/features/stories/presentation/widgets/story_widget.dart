import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoryWidget extends StatelessWidget {
  final String displayName;
  final String firstStoryImageUrl;
  final DateTime firestStoryUploadTime;
  const StoryWidget({
    super.key,
    required this.displayName,
    required this.firstStoryImageUrl,
    required this.firestStoryUploadTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          ImageWidget(
            imagePath: firstStoryImageUrl,
            width: 50,
            height: 50,
            radius: BorderRadius.circular(50),
            fit: BoxFit.cover,
          ),
          horizontalSpacing(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.whiteColor,
                ),
              ),
              verticalSpacing(10),
              Text(
                "${DateFormat('dd MMM yyy').format(firestStoryUploadTime)} ${DateFormat.jm().format(firestStoryUploadTime)}",
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.greyColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
