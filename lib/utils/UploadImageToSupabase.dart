import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/common/snackbar.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> uploadImageToSupabase(BuildContext context, Uint8List image,
    String bucketname, String path) async {
  try {
    final String imageurl;
    final response =
        await supabaseClient.storage.from(bucketname).uploadBinary(path, image,
            fileOptions: const FileOptions(
              upsert: true,
            ));
    // if (response != null) {
    //   showCustomSnackbar(
    //       context: context,
    //       message: 'image uploaded successfully ',
    //       backgroundColor: Colors.black);
    // } else {
    //   showCustomSnackbar(
    //       context: context,
    //       message: 'Error: image upload failed ${}',
    //       backgroundColor: Colors.black);
    // }

    imageurl = supabaseClient.storage.from(bucketname).getPublicUrl(path);
    return imageurl;
  } catch (e) {
    throw Exception(e);
    // showCustomSnackbar(
    //     context: context,
    //     message: 'Error: File upload failed ',
    //     backgroundColor: Colors.black);
  }
}
