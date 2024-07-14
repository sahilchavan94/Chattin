import 'dart:developer';
import 'dart:io';

import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/material.dart';
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
            type: ToastificationType.success);
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
      body: Center(
        child: isDownloading
            ? const CircularProgressIndicator()
            : InteractiveViewer(
                child: ImageWidget(
                  imagePath: widget.imageUrl,
                  fit: BoxFit.cover,
                  isImageFromChat: true,
                ),
              ),
      ),
    );
  }
}
