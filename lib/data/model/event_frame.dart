
class EventFrameModel {

  final String uid;
  final String frame_type; // type_a, type_b ...
  final String name;
  final String background_color;
  final int index;
  final String original_image_filepath;
  final String preview_image_filepath;
  final int event_id;
  final int partner_id;
  final DateTime createdDate;
  final DateTime updatedDate;

  EventFrameModel({
    required this.uid,
    required this.frame_type,
    required this.name,
    required this.background_color,
    required this.index,
    required this.original_image_filepath,
    required this.preview_image_filepath,
    required this.event_id,
    required this.partner_id,
    required this.createdDate,
    required this.updatedDate,
  });

  factory EventFrameModel.fromJson(Map<String, dynamic> json) {
    return EventFrameModel(
      uid: json['uid'] as String,
      frame_type: json['frame_type'] as String,
      name: json['name'] as String,
      background_color: json['background_color'] as String,
      index: json['index'] as int,
      original_image_filepath: json['original_image_filepath'] as String,
      preview_image_filepath: json['preview_image_filepath'] as String,
      event_id: json['event_id'] as int,
      partner_id: json['partner_id'] as int,
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: DateTime.parse(json['updated_date']),
    );
  }

  static List<EventFrameModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EventFrameModel.fromJson(json)).toList();
  }

}

