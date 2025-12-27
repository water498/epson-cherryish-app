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
  Future<PrintQueueResponse> getPrintQueues({
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

    // Handle both response formats
    if (response.data is List) {
      // If API returns a list directly
      final items = (response.data as List)
          .map((item) => PrintQueueItem.fromJson(item as Map<String, dynamic>))
          .toList();
      return PrintQueueResponse(count: items.length, items: items);
    } else {
      // If API returns the expected object format
      return PrintQueueResponse.fromJson(response.data);
    }
  }
}
