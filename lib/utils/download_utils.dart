import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DownloadUtils {
  DownloadUtils._();

  static Future<File> loadImageFromUrl(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    return file;
  }

}