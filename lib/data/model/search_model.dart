class SearchHistoryModel {
  final String keyword;
  final bool isEvent;
  final String id;
  final String? event_name;
  final int? event_id;
  final String? place_name;

  SearchHistoryModel({
    required this.keyword,
    required this.isEvent,
    required this.id,
    this.event_name,
    this.event_id,
    this.place_name
  });

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'isEvent': isEvent,
      'id': id,
      'event_name': event_name,
      'event_id': event_id,
      'place_name': place_name,
    };
  }

  // JSON에서 객체로 변환
  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      keyword: json['keyword'],
      isEvent: json['isEvent'],
      id: json['id'],
      event_name: json['event_name'],
      event_id: json['event_id'],
      place_name: json['place_name'],
    );
  }
}




class SearchResponseModel {
  final int id;
  final String event_name;
  final String place_name;
  final int event_id;
  final bool is_show;
  final DateTime start_date;
  final DateTime end_date;

  SearchResponseModel({
    required this.id,
    required this.event_name,
    required this.place_name,
    required this.event_id,
    required this.is_show,
    required this.start_date,
    required this.end_date,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      id: json['id'],
      event_name: json['event_name'],
      place_name: json['place_name'],
      event_id: json['event_id'],
      is_show: json['is_show'],
      start_date: DateTime.parse(json['start_date']),
      end_date: DateTime.parse(json['end_date']),
    );
  }

  static List<SearchResponseModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SearchResponseModel.fromJson(json)).toList();
  }

}