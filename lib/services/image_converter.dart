import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImageConverter {
  static Future<String> toBase64String(Object object) async {
    switch (object) {
      case == XFile:
        return base64Encode(await (object as XFile).readAsBytes());
      case == File:
        return base64Encode(await (object as File).readAsBytes());
      case == Uint8List:
        return base64Encode(object as Uint8List);
      case == List<int>:
        return base64Encode(object as List<int>);
      default:
        return '';
    }
  }

  static Uint8List fromBase64String(String base64String) {
    return base64Decode(base64String);
  }
}
