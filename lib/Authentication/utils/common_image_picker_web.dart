import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';

Future<Uint8List?> pickImage() async {
  return await ImagePickerWeb.getImageAsBytes();
}
