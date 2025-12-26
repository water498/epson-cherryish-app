import 'dart:io';
import '../core/cache/seeya_cache_managers.dart';

class DownloadUtils {
  DownloadUtils._();

  static Future<File> loadImageFromUrl(String url) async {
    var file = await SeeyaCacheManagers.instance.getSingleFile(url);
    return file;
  }

}