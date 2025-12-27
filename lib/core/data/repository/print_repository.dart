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
}
