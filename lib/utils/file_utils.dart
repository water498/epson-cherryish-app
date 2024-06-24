import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FileUtils {

  static Future<File> findFileFromUrl(String imageUrl) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(imageUrl);
    return file;
  }

}