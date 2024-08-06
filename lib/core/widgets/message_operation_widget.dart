import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/confirmation_dialog.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MessageOperationsDialog extends StatelessWidget {
  final String messageId;
  final String text;
  final MessageType messageType;
  final String receiverId;
  final String senderId;
  final bool isMe;
  const MessageOperationsDialog({
    super.key,
    required this.messageType,
    required this.messageId,
    required this.text,
    required this.receiverId,
    required this.senderId,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: (size.width) * .9,
      height: messageType == MessageType.deleted
          ? size.height * .21
          : (size.height * .25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (messageType != MessageType.deleted)
            GestureDetector(
              onTap: () {
                context.pop();
                context.push(RoutePath.forwardChat.path, extra: {
                  'text': text,
                  'messageType': messageType,
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Forward this message',
                    style: AppTheme.darkThemeData.textTheme.displayMedium!
                        .copyWith(
                      color: AppPallete.blueColor,
                    ),
                  ),
                  horizontalSpacing(5),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppPallete.blueColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          if (messageType != MessageType.deleted) verticalSpacing(12),
          if (messageType != MessageType.deleted)
            const Divider(
              thickness: .1,
            ),
          if (messageType != MessageType.deleted) verticalSpacing(12),
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
          verticalSpacing(20),
          GestureDetector(
            onTap: () {
              context.pop();
              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmationDialogWidget(
                    onPressed: () {
                      context.read<ChatCubit>().deleteMessageForSender(
                            messageId: messageId,
                            senderId: senderId,
                            receiverId: receiverId,
                          );
                      context.pop();
                    },
                    approvalText: 'Delete',
                    rejectionText: 'Cancel',
                    title: 'Delete message for you',
                    description:
                        "This message will be deleted for the sender only, the receiver will still be able to see it",
                  );
                },
              );
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
          if (messageType != MessageType.deleted && isMe)
            GestureDetector(
              onTap: () {
                context.pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialogWidget(
                      onPressed: () {
                        context.read<ChatCubit>().deleteMessageForEveryone(
                              messageId: messageId,
                              senderId: senderId,
                              receiverId: receiverId,
                            );
                        context.pop();
                      },
                      approvalText: 'Delete',
                      rejectionText: 'Cancel',
                      title: 'Delete message for everyone',
                      description: "This message will be deleted for everyone",
                    );
                  },
                );
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
                    style:
                        AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                      color: AppPallete.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
