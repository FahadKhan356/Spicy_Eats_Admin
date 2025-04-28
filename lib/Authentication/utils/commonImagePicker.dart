//image picker
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:html' as html;

var isimage = StateProvider<bool>((ref) => true);

Future<Uint8List?> pickImage() async {
  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  await uploadInput.onChange.first;

  if (uploadInput.files!.isNotEmpty) {
    final html.File file = uploadInput.files!.first;
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    await reader.onLoad.first;
    return Uint8List.fromList(reader.result as List<int>);
  }
  return null;
}
