import 'package:dio/dio.dart';
import 'package:seeya/core/data/model/print/print_models.dart';
import 'package:seeya/core/services/dio_service.dart';

class PrintRepository {
  final Dio _dio = DioService.to.dio;

  /// POST /api/v1/mobile/print/queue
  /// 프린트 큐 생성
  Future<PrintQueue> createPrintQueue(CreatePrintQueueRequest request) async {
    final response = await _dio.post(
      '/api/v1/mobile/print/queue',
      data: request.toJson(),
    );

    return PrintQueue.fromJson(response.data);
  }

  /// GET /api/v1/mobile/print/queue
  /// 프린트 히스토리 목록 조회
  Future<List<PrintQueue>> getPrintQueues({
    required int skip,
    required int limit,
  }) async {
    final response = await _dio.get(
      '/api/v1/mobile/print/queue',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    // API returns a list directly
    return (response.data as List)
        .map((item) => PrintQueue.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/v1/mobile/print/queue/{queue_id}/reprint
  /// 프린트 큐 재출력
  Future<PrintQueue> reprintQueue(int queueId) async {
    final response = await _dio.post(
      '/api/v1/mobile/print/queue/$queueId/reprint',
    );

    return PrintQueue.fromJson(response.data);
  }
}
