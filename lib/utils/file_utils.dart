import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logger/logger.dart';

class FileUtils {
  FileUtils._();

  static Future<File> findFileFromUrl(String imageUrl) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(imageUrl);
    return file;
  }


  static Future<Uint8List> getUint8listFromUrl(String imageUrl) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(imageUrl);
    return await file.readAsBytes();
  }

  static Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      Logger().e("Failed to delete file: $e");
    }
  }

}