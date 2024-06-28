import 'dart:developer';
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
      log("error is ${e.toString()}");
      return null;
    }
  }
}