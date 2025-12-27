import 'package:dio/dio.dart';
import 'package:seeya/core/data/model/event/event.dart';
import 'package:seeya/core/data/model/event/event_detail_response.dart';
import 'package:seeya/core/services/dio_service.dart';

class EventRepository {
  final Dio _dio = DioService.to.dio;

  /// GET /api/v1/mobile/event
  /// Event 목록 조회
  Future<List<Event>> getEvents({String? eventIds}) async {
    final response = await _dio.get(
      '/api/v1/mobile/event',
      queryParameters: eventIds != null ? {'event_ids': eventIds} : null,
    );

    return (response.data as List).map((json) => Event.fromJson(json)).toList();
  }

  /// GET /api/v1/mobile/event/search
  /// Event 검색
  Future<List<Event>> searchEvents(String query) async {
    final response = await _dio.get(
      '/api/v1/mobile/event/search',
      queryParameters: {'query': query},
    );

    return (response.data as List).map((json) => Event.fromJson(json)).toList();
  }

  /// GET /api/v1/mobile/event/{event_id}
  /// Event 상세 정보 조회
  Future<EventDetailResponse> getEventDetail(int eventId) async {
    final response = await _dio.get('/api/v1/mobile/event/$eventId');

    return EventDetailResponse.fromJson(response.data);
  }
}
