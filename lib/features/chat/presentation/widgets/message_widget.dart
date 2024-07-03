import 'package:chattin/core/enum/enums.dart';
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
  final MessageType messageType;
  const MessageWidget({
    super.key,
    required this.text,
    required this.isMe,
    required this.imageUrl,
    required this.timeSent,
    required this.name,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
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
                  //16 16 26 26
                  fit: BoxFit.fill,
                  radius: BorderRadius.circular(20),
                ),
                horizontalSpacing(6),
              ],
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 110,
                ),
                decoration: BoxDecoration(
                  color: !isMe
                      ? AppPallete.bottomSheetColor
                      : AppPallete.blueColor.withOpacity(.15),
                  borderRadius: isMe
                      ? BorderRadius.circular(10).copyWith(
                          bottomRight: const Radius.circular(0),
                        )
                      : BorderRadius.circular(10).copyWith(
                          bottomLeft: const Radius.circular(0),
                        ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 9,
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (messageType == MessageType.text)
                      Text(
                        text,
                        style: AppTheme.darkThemeData.textTheme.displaySmall!
                            .copyWith(
                          color: AppPallete.whiteColor,
                        ),
                        maxLines: 10,
                        overflow:
                            TextOverflow.visible, // Ensure text can overflow
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ImageWidget(
                          imagePath: imageUrl,
                          radius: BorderRadius.circular(10),
                        ),
                      ),
                    verticalSpacing(messageType == MessageType.image ? 10 : 4),
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
                        horizontalSpacing(7.5),
                        Text(
                          DateFormat.jm().format(timeSent),
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
          verticalSpacing(9),
        ],
      ),
    );
  }
}
