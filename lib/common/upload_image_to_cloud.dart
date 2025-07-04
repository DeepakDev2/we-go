import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:we_go/secrets/keys.dart';

Future<String?> uploadImageOnCloud(File file) async {
  try {
    final cloudinary = Cloudinary.signedConfig(
      apiKey: apiKey,
      apiSecret: apiSecret,
      cloudName: cloudName,
    );

    final res = await cloudinary.upload(file: file.path);
    return res.secureUrl;
  } catch (e) {
    return null;
  }
}
