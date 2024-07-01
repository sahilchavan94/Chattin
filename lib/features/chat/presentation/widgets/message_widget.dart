import 'dart:developer';

import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String name;
  final DateTime timeSent;
  final bool isMe;
  const MessageWidget({
    super.key,
    required this.text,
    required this.isMe,
    required this.imageUrl,
    required this.timeSent,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    log(timeSent.toString());
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              ImageWidget(
                imagePath: imageUrl,
                width: 26,
                height: 26,
                fit: BoxFit.fill,
                radius: BorderRadius.circular(20),
              ),
              horizontalSpacing(6),
            ],
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: AppPallete.bottomSheetColor,
                  borderRadius: isMe
                      ? BorderRadius.circular(6).copyWith(
                          bottomRight: const Radius.circular(0),
                        )
                      : BorderRadius.circular(6).copyWith(
                          bottomLeft: const Radius.circular(0),
                        ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      text,
                      style: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: AppPallete.whiteColor,
                      ),
                      maxLines: 10,
                      overflow:
                          TextOverflow.visible, // Ensure text can overflow
                    ),
                    verticalSpacing(4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isMe ? "You" : name,
                          style: AppTheme.darkThemeData.textTheme.displaySmall!
                              .copyWith(
                            color: isMe
                                ? AppPallete.blueColor
                                : AppPallete.redColor,
                            fontSize: 11,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Ensure text can overflow
                        ),
                        horizontalSpacing(5),
                        Text(
                          "${DateFormat.jm().format(timeSent)} ${DateFormat('dd MM yyyy').format(timeSent)}",
                          style: AppTheme.darkThemeData.textTheme.displaySmall!
                              .copyWith(
                            color: AppPallete.greyColor,
                            fontSize: 11,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Ensure text can overflow
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isMe) ...[
              horizontalSpacing(6),
              ImageWidget(
                imagePath: imageUrl,
                width: 26,
                height: 26,
                fit: BoxFit.fill,
                radius: BorderRadius.circular(20),
              ),
            ],
          ],
        ),
        verticalSpacing(7.5),
      ],
    );
  }
}
