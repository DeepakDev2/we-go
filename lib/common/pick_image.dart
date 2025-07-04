import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(ImageSource source) async {
  try {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return null;
    return File(pickedImage.path);
  } catch (e) {
    return null;
  }
}
