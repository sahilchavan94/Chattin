import 'dart:io';

import 'package:chattin/core/utils/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImagePreview extends StatelessWidget {
  final File file;
  final Function onPressed;
  const ImagePreview({
    super.key,
    required this.file,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send photo"),
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          onPressed: () {
            onPressed();
          },
          autofocus: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppPallete.bottomSheetColor,
          child: IconButton(
            onPressed: () {
              context.pop();
              onPressed();
            },
            icon: const Icon(
              Icons.send,
              color: AppPallete.blueColor,
            ),
          ),
        ),
      ),
      body: Center(
        child: Image.file(
          file,
          fit: BoxFit.cover,
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * .6,
        ),
      ),
    );
  }
}
