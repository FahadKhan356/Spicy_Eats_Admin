import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:spicy_eats_admin/config/supabaseconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> uploadImageToSupabase(BuildContext context, Uint8List image,
    String bucketname, String path) async {
  try {
    // final String imageurl;
   
        await supabaseClient.storage.from(bucketname).updateBinary(path, image,
            fileOptions: const FileOptions(
              contentType: 'image/png',
              upsert: false,
            ));
  
    final String imageurl =
        supabaseClient.storage.from(bucketname).getPublicUrl(path);
    debugPrint(' Image url - $imageurl');
    return imageurl;
  } catch (e) {
    throw Exception(e);
  
  }
 
}
