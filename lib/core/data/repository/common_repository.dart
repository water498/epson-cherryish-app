import 'package:dio/dio.dart';
import 'package:seeya/core/data/model/common/common_models.dart';
import 'package:seeya/core/services/dio_service.dart';

class CommonRepository {
  final Dio _dio = DioService.to.dio;

  /// GET /api/v1/mobile/common/home/best/frame
  /// Home Best Frame 리스트 조회
  Future<List<HomeBestFrame>> getHomeBestFrames({bool? isShow}) async {
    final response = await _dio.get(
      '/api/v1/mobile/common/home/best/frame',
      queryParameters: isShow != null ? {'is_show': isShow} : null,
    );

    return (response.data as List)
        .map((json) => HomeBestFrame.fromJson(json))
        .toList();
  }

  /// GET /api/v1/mobile/common/qna
  /// QNA 리스트 조회
  Future<List<Qna>> getQnas({String? lang}) async {
    final response = await _dio.get(
      '/api/v1/mobile/common/qna',
      queryParameters: lang != null ? {'lang': lang} : null,
    );

    return (response.data as List)
        .map((json) => Qna.fromJson(json))
        .toList();
  }
}
