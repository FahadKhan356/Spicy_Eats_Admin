//image picker
// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:html' as html;

import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

//common image upload on supabase storage

Future<String?> uploadSupabseStorageGetRrl(
    {required String foldername,
    required String imagepath,
    required Uint8List file}) async {
  final imageurl;
  try {
    final storageResponse = await supabaseClient.storage
        .from(foldername)
        .uploadBinary(imagepath, file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true));

    if (storageResponse.isNotEmpty && storageResponse != null) {
      imageurl =
          supabaseClient.storage.from(foldername).getPublicUrl(imagepath);
      return imageurl;
    } else {
      debugPrint('Error uploading file');
      return null;
    }
  } catch (e) {
    throw Exception('error in upload image in storage  $e');
  }
}
