import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReplyDialogWidget extends StatelessWidget {
  final MessageType messageType;
  final String senderId;
  final String receiverId;
  final String repliedTo;
  ReplyDialogWidget({
    super.key,
    required this.messageType,
    required this.senderId,
    required this.receiverId,
    required this.repliedTo,
  });

  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      iconPadding: const EdgeInsets.all(5),
      iconColor: AppPallete.greyColor,
      backgroundColor: AppPallete.bottomSheetColor,
      surfaceTintColor: AppPallete.bottomSheetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      content: SizedBox(
        width: (size.width) * .9,
        height: messageType == MessageType.image
            ? (size.height * .35)
            : (size.height * .21),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Replying to ",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.blueColor,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(10),
            if (messageType == MessageType.text)
              Text(
                repliedTo.length > 45
                    ? "${repliedTo.substring(0, 45)}..."
                    : repliedTo,
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.greyColor,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              )
            else
              ImageWidget(
                imagePath: repliedTo,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(6),
              ),
            verticalSpacing(size.width * .03),
            InputWidget(
              maxLines: 1,
              height: 45,
              hintText: "Reply to this message",
              textEditingController: _replyController,
              validator: (String val) {},
              suffixIcon: const Icon(
                Icons.reply,
                size: 20,
                color: AppPallete.whiteColor,
              ),
              fillColor: AppPallete.bottomSheetColor,
              onSuffixIconPressed: () {},
            ),
            verticalSpacing(10),
            ButtonWidget(
              height: 40,
              buttonText: "Send Reply",
              isLoading: context.watch<ChatCubit>().state.chatStatus ==
                  ChatStatus.loading,
              onPressed: () {
                if (_replyController.text.replaceAll(" ", "").isEmpty) {
                  return;
                }
                context.pop();
                context.read<ChatCubit>().sendReply(
                      text: _replyController.text,
                      repliedTo: repliedTo,
                      recieverId: receiverId,
                      senderId: senderId,
                      repliedToType: messageType,
                    );
              },
            ),
            verticalSpacing(10),
          ],
        ),
      ),
    );
  }
}