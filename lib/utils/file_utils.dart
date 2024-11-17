import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

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


  static Future<void> deleteFile(String path) async {

    if(path.isEmpty) return;

    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      } else {
        Logger().e("File does not exist, no need to delete.");
      }
    } catch (e) {
      Logger().e("Error deleting file: $e");
    }
  }

  static Future<void> clearTempDirExceptLibCachedImage() async {

    final Directory tempDir = await getTemporaryDirectory();

    // 임시 디렉토리 내의 모든 항목을 가져옴
    final List<FileSystemEntity> entities = await tempDir.list().toList();

    for (FileSystemEntity entity in entities) {
      // libCachedImage 폴더는 건너뛰기
      if (entity.path.contains('libCachedImage') || entity.path.contains("google-sdks-events")) {
        continue;
      }
      try {
        // 항목이 디렉토리인 경우 삭제
        if (entity is Directory) {
          await entity.delete(recursive: true);
        }
        // 항목이 파일인 경우 삭제
        else if (entity is File) {
          await entity.delete();
        }
      } catch (e) {
        // 존재하지 않는 파일을 삭제하려 할 때 예외 발생
        if (e is FileSystemException) {
          Logger().e('File or directory does not exist: ${entity.path}');
        } else {
          Logger().e('Failed to delete ${entity.path}: $e');
        }
      }
    }
    Logger().d('Temp direcotyr cleared except for libCachedImage');
  }

  static Future<void> clearDocumentDir() async {
    try {
      final Directory documentDir = await getApplicationDocumentsDirectory();

      if (documentDir.existsSync()) {
        documentDir.listSync().forEach((entity) {
          if (entity is File) {
            entity.deleteSync();
          } else if (entity is Directory) {
            entity.deleteSync(recursive: true);
          }
        });
      }

      Logger().d("Document directory all deleted");
    } catch (e) {
      Logger().e("Error deleting document directory contents: $e");
    }
  }


}