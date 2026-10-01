import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spicy_eats_admin/config/supabaseconfig.dart';

Future<String> uploadImageToSupabase(
  Uint8List image,
  String bucketName,
  String path, {
  String contentType = 'image/jpeg',
}) async {
  final cleanPath = path.startsWith('/') ? path.substring(1) : path;

  await supabaseClient.storage
      .from(bucketName)
      .uploadBinary(
        cleanPath,
        image,
        fileOptions: FileOptions(
          contentType: contentType,
          upsert: true,
          cacheControl: '3600',
        ),
      );

  return supabaseClient.storage.from(bucketName).getPublicUrl(cleanPath);
}
