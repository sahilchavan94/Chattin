import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Picker {
  //pick image
  static Future<File?> pickImage(ImageSource imageSource) async {
    try {
      final xFile = await ImagePicker().pickImage(
        source: imageSource,
      );
      if (xFile != null) {
        return File(xFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<File>?> pickMultipleImages() async {
    try {
      final xFile = await ImagePicker().pickMultiImage(
        limit: 5,
      );
      return xFile.map((e) => File(e.path)).toList();
    } catch (e) {
      return null;
    }
  }
}
