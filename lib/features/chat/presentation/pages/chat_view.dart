// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/picker.dart';
import 'package:chattin/core/widgets/bottom_sheet_for_image.dart';
import 'package:chattin/core/widgets/failure_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/core/widgets/reply_dialog_widget.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/cubit/chat_cubit.dart';
import 'package:chattin/features/chat/presentation/widgets/contact_widget.dart';
import 'package:chattin/features/chat/presentation/widgets/date_widget.dart';
import 'package:chattin/features/chat/presentation/widgets/message_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatView extends StatefulWidget {
  final String uid;
  final String displayName;
  final String imageUrl;
  const ChatView({
    super.key,
    required this.uid,
    required this.displayName,
    required this.imageUrl,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<ChatCubit>().getChatStream(receiverId: widget.uid);
    context.read<ChatCubit>().getChatStatus(widget.uid);
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }
  }

  Future<void> _selectImage(ImageSource imageSource) async {
    final pickedImage = await Picker.pickImage(imageSource);
    if (pickedImage != null) {
      final sender = context.read<ProfileCubit>().state.userData!;
      context.push(
        RoutePath.imagePreview.path,
        extra: {
          'file': pickedImage,
          'onPressed': () {
            context.read<ChatCubit>().sendFileMessage(
                  recieverId: widget.uid,
                  sender: sender,
                  messageType: MessageType.image,
                  file: pickedImage,
                );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 10,
        shadowColor: AppPallete.bottomSheetColor,
        backgroundColor: AppPallete.backgroundColor,
        title: ContactWidget(
          uid: widget.uid,
          displayName: widget.displayName,
          imageUrl: widget.imageUrl,
          status: context
                  .read<ChatCubit>()
                  .state
                  .currentChatStatus
                  ?.toStringValue() ??
              Status.unavailable.toStringValue(),
          radius: 50,
        ),
        titleSpacing: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.srgbToLinearGamma(),
              opacity: .3,
              image: AssetImage(
                "assets/images/bg.png",
              ),
            ),
          ),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InputWidget(
                        hintText: 'Message',
                        height: 47.5,
                        textEditingController: _messageController,
                        validator: (String val) {},
                        suffixIcon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(
                            Icons.photo_library,
                            color: AppPallete.greyColor,
                          ),
                        ),
                        onSuffixIconPressed: () {
                          showBottomSheetForPickingImage(
                            context: context,
                            onClick1: () {
                              context.pop();
                              _selectImage(ImageSource.camera);
                            },
                            onClick2: () {
                              context.pop();
                              _selectImage(ImageSource.gallery);
                            },
                            title: "Share images ",
                            subTitle:
                                "Sending images to each other is now easy 📸",
                          );
                        },
                        fillColor: AppPallete.backgroundColor,
                        showBorder: false,
                        borderRadius: 60,
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (_messageController.text
                            .replaceAll(" ", "")
                            .isEmpty) {
                          return;
                        }
                        context.read<ChatCubit>().sendMessage(
                              text: _messageController.text,
                              recieverId: widget.uid,
                              sender:
                                  context.read<ProfileCubit>().state.userData!,
                            );
                        setState(() {
                          _messageController.clear();
                        });
                      },
                      mini: true,
                      backgroundColor:
                          context.watch<ChatCubit>().state.chatStatus ==
                                  ChatStatus.loading
                              ? AppPallete.blueColor.withOpacity(.7)
                              : AppPallete.blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          50,
                        ),
                      ),
                      child: context.watch<ChatCubit>().state.sendingMessage ==
                              true
                          ? const SizedBox(
                              height: 23,
                              width: 23,
                              child: CircularProgressIndicator(
                                color: AppPallete.whiteColor,
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              size: 20,
                              color: AppPallete.whiteColor,
                            ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.chatStatus == ChatStatus.loading) {
            return const CircularProgressIndicator();
          }
          if (state.chatStatus == ChatStatus.chatFailure) {
            return const FailureWidget();
          }

          final List<MessageEntity> messages = state.currentChatMessages ?? [];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.srgbToLinearGamma(),
                opacity: .3,
                image: AssetImage(
                  "assets/images/bg.png",
                ),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0,
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final userData =
                        context.read<ProfileCubit>().state.userData!;
                    final isMe = messages[index].senderId == userData.uid;
                    if (!messages[index].status && !isMe) {
                      context.read<ChatCubit>().setMessageStatus(
                            receiverId: messages[index].receiverId,
                            senderId: messages[index].senderId,
                            messageId: messages[index].messageId,
                          );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index == 0 ||
                            index != messages.length - 1 &&
                                messages[index - 1].timeSent!.day !=
                                    messages[index].timeSent!.day)
                          DateWidget(
                            timeSent: messages[index].timeSent!,
                          ),
                        SwipeTo(
                          iconColor: AppPallete.whiteColor,
                          iconOnLeftSwipe: Icons.arrow_forward,
                          iconOnRightSwipe: Icons.arrow_back,
                          onRightSwipe: (details) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return ReplyDialogWidget(
                                  messageType: messages[index].messageType,
                                  senderId: userData.uid,
                                  receiverId: isMe
                                      ? messages[index].receiverId
                                      : messages[index].senderId,
                                  repliedTo: messages[index].text,
                                );
                              },
                            );
                          },
                          onLeftSwipe: (details) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return ReplyDialogWidget(
                                  messageType: messages[index].messageType,
                                  senderId: userData.uid,
                                  receiverId: isMe
                                      ? messages[index].receiverId
                                      : messages[index].senderId,
                                  repliedTo: messages[index].text,
                                );
                              },
                            );
                          },
                          child: MessageWidget(
                            isReply: messages[index].isReply,
                            repliedTo: messages[index].repliedTo,
                            repliedToType: messages[index].repliedToType,
                            messageType: messages[index].messageType,
                            text: messages[index].text,
                            name: isMe
                                ? userData.displayName
                                : widget.displayName,
                            isMe: isMe,
                            imageUrl:
                                isMe ? userData.imageUrl : widget.imageUrl,
                            timeSent: messages[index].timeSent!,
                            status: messages[index].status,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
