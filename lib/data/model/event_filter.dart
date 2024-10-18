class EventFilterModel {

  final String uid;
  final String type; // lt, lb, rt, rb
  final String name;
  final int index;
  final String? image_filepath;
  final String event_editor_frame_uid;
  final int event_id;
  final int partner_id;
  final DateTime created_date;
  final DateTime updated_date;

  EventFilterModel({
    required this.uid,
    required this.type,
    required this.name,
    required this.index,
    required this.image_filepath,
    required this.event_editor_frame_uid,
    required this.event_id,
    required this.partner_id,
    required this.created_date,
    required this.updated_date,
  });

  factory EventFilterModel.fromJson(Map<String, dynamic> json) {
    return EventFilterModel(
      uid: json['uid'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      index: json['index'] as int,
      image_filepath: json['image_filepath'] as String?,
      event_editor_frame_uid: json['event_editor_frame_uid'] as String,
      event_id: json['event_id'] as int,
      partner_id: json['partner_id'] as int,
      created_date: DateTime.parse(json['created_date']),
      updated_date: DateTime.parse(json['updated_date']),
    );
  }

  static List<EventFilterModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EventFilterModel.fromJson(json)).toList();
  }

}