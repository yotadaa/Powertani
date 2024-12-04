import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File?> compressImage(File image) async {
  // Get the file path
  String path = image.path;

  // Use flutter_image_compress to compress the image
  var result = await FlutterImageCompress.compressAssetImage(
    path,
    minWidth: 250, // Min width for the compressed image
    minHeight: 250, // Min height for the compressed image
    quality: 75, // Compression quality (0 to 100)
    rotate: 0, // Rotation if needed
  );

  if (result == null) return null;

  // Return the compressed file
  return File.fromRawPath(result);
}
