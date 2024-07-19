import 'dart:developer';
import 'dart:io';

import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:chattin/features/chat/domain/entities/message_entity.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ProfileImageView extends StatefulWidget {
  final String imageUrl;
  final String displayName;
  final bool? isAnImageFromChat;

  const ProfileImageView({
    super.key,
    required this.imageUrl,
    required this.displayName,
    this.isAnImageFromChat,
  });

  @override
  State<ProfileImageView> createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> {
  bool isDownloading = false;
  late List<MessageEntity?> imagesInChats;

  @override
  void initState() {
    super.initState();
    imagesInChats = context
            .read<ChatCubit>()
            .state
            .currentChatMessages
            ?.where((element) => element.messageType == MessageType.image)
            .toList() ??
        [];
  }

  Future<void> _saveImage(String url) async {
    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      final imageId = const Uuid().v1();

      // Create an image name
      var filename = '${dir.path}/$imageId.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        setState(() {
          isDownloading = false;
        });
        showToast(
          content: ToastMessages.imageDownload,
          type: ToastificationType.success,
        );
      }
      setState(() {
        isDownloading = false;
      });
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      showToast(
        content: ToastMessages.defaultFailureMessage,
        description: ToastMessages.defaultFailureDescription,
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.displayName),
        centerTitle: true,
        backgroundColor: AppPallete.backgroundColor,
        actions:
            widget.isAnImageFromChat != null && widget.isAnImageFromChat == true
                ? [
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          isDownloading = true;
                        });

                        try {
                          await _saveImage(widget.imageUrl);
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      icon: const Icon(
                        Icons.file_download_outlined,
                      ),
                      color: AppPallete.blueColor,
                    ),
                  ]
                : null,
      ),
      bottomNavigationBar:
          widget.isAnImageFromChat != null && widget.isAnImageFromChat == true
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: imagesInChats.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ImageWidget(
                              height: 70,
                              width: 80,
                              imagePath: imagesInChats[index]!.text,
                              fit: BoxFit.cover,
                              radius: BorderRadius.circular(2),
                              isImageFromChat: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
      body: Center(
        child: isDownloading
            ? const CircularProgressIndicator()
            : InteractiveViewer(
                minScale: 1,
                constrained: true,
                child: ImageWidget(
                  imagePath: widget.imageUrl,
                  fit: BoxFit.fill,
                  isImageFromChat: true,
                ),
              ),
      ),
    );
  }
}
