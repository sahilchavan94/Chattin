import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MessageOperationsDialog extends StatelessWidget {
  final String messageId;
  final MessageType messageType;
  final String receiverId;
  final String senderId;
  const MessageOperationsDialog({
    super.key,
    required this.messageType,
    required this.messageId,
    required this.receiverId,
    required this.senderId,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: AppPallete.backgroundColor,
      surfaceTintColor: AppPallete.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      content: SizedBox(
        width: (size.width) * .9,
        height: messageType == MessageType.deleted
            ? size.height * .21
            : (size.height * .25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Forward this message',
                  style:
                      AppTheme.darkThemeData.textTheme.displayMedium!.copyWith(
                    color: AppPallete.blueColor,
                  ),
                ),
                horizontalSpacing(10),
                const Icon(
                  Icons.arrow_forward,
                  color: AppPallete.blueColor,
                  size: 18,
                ),
              ],
            ),
            verticalSpacing(12),
            const Divider(
              thickness: .1,
            ),
            verticalSpacing(12),
            Text(
              'Dangerous Area',
              style: AppTheme.darkThemeData.textTheme.displayMedium!.copyWith(
                color: AppPallete.errorColor,
              ),
            ),
            verticalSpacing(4),
            Text(
              'After a message is deleted it can\'t be recovered. Be sure to perform these actions',
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
            ),
            verticalSpacing(15),
            GestureDetector(
              onTap: () {
                context.read<ChatCubit>().deleteMessageForSender(
                      messageId: messageId,
                      senderId: senderId,
                      receiverId: receiverId,
                    );
                context.pop();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.delete,
                    color: AppPallete.whiteColor,
                    size: 18,
                  ),
                  horizontalSpacing(10),
                  Text(
                    'Delete message for you',
                    style:
                        AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                      color: AppPallete.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacing(20),
            if (messageType != MessageType.deleted)
              GestureDetector(
                onTap: () {
                  context.read<ChatCubit>().deleteMessageForEveryone(
                        messageId: messageId,
                        senderId: senderId,
                        receiverId: receiverId,
                      );
                  context.pop();
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_forever,
                      color: AppPallete.whiteColor,
                      size: 18,
                    ),
                    horizontalSpacing(10),
                    Text(
                      'Delete message for everyone',
                      style: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: AppPallete.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          curve: Curves.fastEaseInToSlowEaseOut,
        )
        .scale(
          curve: Curves.fastEaseInToSlowEaseOut,
        );
  }
}
