import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String name;
  final DateTime timeSent;
  final bool isMe;
  final bool isReply;
  final String? repliedTo;
  final MessageType? repliedToType;
  final bool status;
  final MessageType messageType;
  const MessageWidget({
    super.key,
    required this.text,
    required this.isMe,
    required this.imageUrl,
    required this.timeSent,
    required this.name,
    required this.messageType,
    required this.status,
    required this.isReply,
    required this.repliedTo,
    required this.repliedToType,
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
                  fit: BoxFit.fill,
                  radius: BorderRadius.circular(20),
                ),
                horizontalSpacing(6),
              ],
              Column(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 120,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppPallete.bottomSheetColor
                          : AppPallete.backgroundColor,
                      borderRadius: isMe
                          ? BorderRadius.circular(12).copyWith(
                              bottomRight: Radius.circular(
                                messageType == MessageType.image ? 10 : 5,
                              ),
                            )
                          : BorderRadius.circular(12).copyWith(
                              bottomLeft: Radius.circular(
                                messageType == MessageType.image ? 10 : 5,
                              ),
                            ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: messageType == MessageType.image ? 4 : 15,
                      vertical: messageType == MessageType.image ? 4 : 9,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (isReply)
                          Container(
                            padding: EdgeInsets.all(
                              repliedToType == MessageType.text ? 10 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppPallete.backgroundColor.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: repliedToType == MessageType.text
                                ? Text(
                                    repliedTo!.length > 25
                                        ? repliedTo!.substring(0, 25)
                                        : repliedTo!,
                                    style: AppTheme
                                        .darkThemeData.textTheme.displaySmall!
                                        .copyWith(
                                      color: AppPallete.greyColor,
                                    ),
                                  )
                                : ImageWidget(
                                    height: 55,
                                    width: 55,
                                    fit: BoxFit.cover,
                                    imagePath: repliedTo!,
                                    radius: BorderRadius.circular(6),
                                  ),
                          ),
                        if (isReply) verticalSpacing(10),
                        if (messageType == MessageType.text)
                          Text(
                            text,
                            style: AppTheme
                                .darkThemeData.textTheme.displaySmall!
                                .copyWith(
                              color: AppPallete.whiteColor,
                            ),
                            maxLines: 10,
                            overflow: TextOverflow
                                .visible, // Ensure text can overflow
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              context.push(
                                RoutePath.imageView.path,
                                extra: {
                                  'displayName': "Photo",
                                  "imageUrl": text,
                                  "isAnImageFromChat": true,
                                },
                              );
                            },
                            child: Stack(
                              children: [
                                ImageWidget(
                                  imagePath: text,
                                  fit: BoxFit.cover,
                                  radius: BorderRadius.circular(10),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: _messageDataWidget(
                                    isMe: isMe,
                                    name: name,
                                    timeSent: timeSent,
                                    status: status,
                                    messageType: messageType,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        verticalSpacing(
                          messageType == MessageType.image ? 0 : 4,
                        ),
                        if (messageType == MessageType.text)
                          _messageDataWidget(
                            isMe: isMe,
                            name: name,
                            timeSent: timeSent,
                            messageType: messageType,
                            status: status,
                          ),
                      ],
                    ),
                  ),
                ],
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

Widget _messageDataWidget({
  required bool isMe,
  required String name,
  required MessageType messageType,
  required DateTime timeSent,
  required bool status,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        isMe ? "You" : name,
        style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
          color: isMe ? AppPallete.blueColor : AppPallete.redColor,
          fontSize: 11,
        ),
        overflow: TextOverflow.ellipsis, // Ensure text can overflow
      ),
      horizontalSpacing(7.5),
      Text(
        DateFormat.jm().format(timeSent),
        style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
          color: AppPallete.whiteColor.withOpacity(.7),
          fontSize: 11,
        ),
        overflow: TextOverflow.ellipsis, // Ensure text can overflow
      ),
      horizontalSpacing(6),
      if (isMe)
        Icon(
          status ? Icons.done_all : Icons.done,
          color: status ? AppPallete.blueColor : AppPallete.greyColor,
          size: 15,
        ),
    ],
  );
}
