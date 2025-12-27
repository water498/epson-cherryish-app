import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:seeya/core/data/model/file/upload_image_response.dart';
import 'package:seeya/core/services/dio_service.dart';

class FileRepository {
  final Dio _dio = DioService.to.dio;

  /// POST /api/v1/mobile/file/upload-image
  /// 이미지 파일 업로드
  Future<UploadImageResponse> uploadImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: basename(file.path),
      ),
    });

    final response = await _dio.post(
      '/api/v1/mobile/file/upload-image',
      data: formData,
    );

    return UploadImageResponse.fromJson(response.data);
  }
}
