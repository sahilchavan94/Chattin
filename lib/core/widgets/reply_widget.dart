import 'package:chattin/core/common/providers/reply_message_provider.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

// class ReplyDialogWidget extends StatelessWidget {
//   final MessageType messageType;
//   final String senderId;
//   final String receiverId;
//   final String repliedTo;
//   ReplyDialogWidget({
//     super.key,
//     required this.messageType,
//     required this.senderId,
//     required this.receiverId,
//     required this.repliedTo,
//   });

//   final TextEditingController _replyController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return AlertDialog(
//       backgroundColor: AppPallete.backgroundColor,
//       surfaceTintColor: AppPallete.backgroundColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(
//           10,
//         ),
//       ),
//       content: SizedBox(
//         width: (size.width) * .9,
//         height: messageType == MessageType.image
//             ? (size.height * .20)
//             : (size.height * .19),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Replying to this message",
//                   style:
//                       AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
//                     color: AppPallete.blueColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     context.pop();
//                   },
//                   child: Text(
//                     'Discard',
//                     style:
//                         AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
//                       color: AppPallete.errorColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             verticalSpacing(15),
//             if (messageType != MessageType.image)
//               Chip(
//                 backgroundColor: AppPallete.blackColor,
//                 surfaceTintColor: AppPallete.blackColor,
//                 visualDensity: VisualDensity.comfortable,
//                 padding: const EdgeInsets.all(6),
//                 side: const BorderSide(
//                   color: AppPallete.blackColor,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(
//                     8,
//                   ),
//                   side: BorderSide.none,
//                 ),
//                 label: Text(
//                   repliedTo,
//                   style:
//                       AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
//                     color: AppPallete.greyColor,
//                   ),
//                   textAlign: TextAlign.start,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 2,
//                 ),
//               )
//             else
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0),
//                 child: ImageWidget(
//                   imagePath: repliedTo,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                   radius: BorderRadius.circular(6),
//                 ),
//               ),
//             verticalSpacing(size.width * .03),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: InputWidget(
//                     maxLines: 1,
//                     height: 42,
//                     hintText: "Reply ",
//                     textEditingController: _replyController,
//                     validator: (String val) {},
//                     showBorder: false,
//                     suffixIcon: const Icon(
//                       Icons.reply,
//                       size: 20,
//                       color: AppPallete.greyColor,
//                     ),
//                     fillColor: AppPallete.bottomSheetColor,
//                     onSuffixIconPressed: () {},
//                   ),
//                 ),
//                 horizontalSpacing(5),
//                 FloatingActionButton(
//                   backgroundColor: AppPallete.blueColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   onPressed: () {
//                     if (_replyController.text.replaceAll(" ", "").isEmpty) {
//                       return;
//                     }
//                     context.read<ChatCubit>().sendReply(
//                           text: _replyController.text,
//                           repliedTo: repliedTo,
//                           recieverId: receiverId,
//                           senderId: senderId,
//                           repliedToType: messageType,
//                         );
//                     context.pop();
//                   },
//                   mini: true,
//                   child: context.watch<ChatCubit>().state.chatStatus ==
//                           ChatStatus.loading
//                       ? const Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : const Icon(
//                           Icons.send,
//                           color: AppPallete.whiteColor,
//                         ),
//                 )
//               ],
//             ),
//             // ButtonWidget(
//             //   height: 40,
//             //   buttonText: "Send Reply",
//             //   isLoading: context.watch<ChatCubit>().state.chatStatus ==
//             //       ChatStatus.loading,
//             //   onPressed: () {
//             //     if (_replyController.text.replaceAll(" ", "").isEmpty) {
//             //       return;
//             //     }
//             //     context.pop();
//             //     context.read<ChatCubit>().sendReply(
//             //           text: _replyController.text,
//             //           repliedTo: repliedTo,
//             //           recieverId: receiverId,
//             //           senderId: senderId,
//             //           repliedToType: messageType,
//             //         );
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     )
//         .animate()
//         .fadeIn(
//           curve: Curves.fastEaseInToSlowEaseOut,
//         )
//         .scale(
//           curve: Curves.fastEaseInToSlowEaseOut,
//         );
//   }
// }

Widget replyWidget({
  required BuildContext context,
  required String sender,
  required bool isMe,
  required String senderImage,
  required String repliedTo,
  required MessageType messageType,
}) {
  return Consumer<ReplyMessageProvider>(
    builder: (BuildContext context, ReplyMessageProvider replyMessageProvider,
        Widget? child) {
      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppPallete.bottomSheetColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageWidget(
                  width: 20,
                  height: 20,
                  radius: BorderRadius.circular(30),
                  imagePath: senderImage,
                  fit: BoxFit.cover,
                ),
                horizontalSpacing(5),
                Text(
                  sender,
                  style:
                      AppTheme.darkThemeData.textTheme.displayMedium!.copyWith(
                    color: isMe ? AppPallete.blueColor : AppPallete.errorColor,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    replyMessageProvider.clearReplyData();
                  },
                  child: const Icon(
                    CupertinoIcons.multiply,
                    color: AppPallete.greyColor,
                    size: 18,
                  ),
                ),
              ],
            ),
            verticalSpacing(10),
            Container(
              decoration: BoxDecoration(
                color: AppPallete.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Text(
                          messageType.convertMessageTypeToString(),
                          style: AppTheme.darkThemeData.textTheme.displayMedium!
                              .copyWith(
                            color: AppPallete.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (messageType == MessageType.image)
                    ImageWidget(
                      imagePath: repliedTo,
                      width: 50,
                      height: 50,
                      radius: BorderRadius.circular(4),
                      fit: BoxFit.cover,
                    )
                  else
                    Text(
                      repliedTo.length > 30
                          ? "${repliedTo.substring(0, 30)}..."
                          : repliedTo,
                      style: AppTheme.darkThemeData.textTheme.displayMedium!
                          .copyWith(
                        color: AppPallete.greyColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  ).animate().slideY(
        begin: 1,
        end: 0,
        curve: Curves.fastEaseInToSlowEaseOut,
      );
}
