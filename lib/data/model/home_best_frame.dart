class HomeBestFrame {

  String uid;
  bool isShow;
  String preview_image_filepath;
  String flipped_image_filepath;
  String thumbnail_image_filepath;
  String name;
  DateTime createdDate;
  DateTime updatedDate;
  int? eventId;

  HomeBestFrame({
    required this.uid,
    required this.isShow,
    required this.preview_image_filepath,
    required this.flipped_image_filepath,
    required this.thumbnail_image_filepath,
    required this.name,
    required this.createdDate,
    required this.updatedDate,
    this.eventId,
  });


  factory HomeBestFrame.fromJson(Map<String, dynamic> json) {
    return HomeBestFrame(
      uid: json['uid'] as String,
      isShow: json['is_show'] as bool,
      preview_image_filepath: json['preview_image_filepath'] as String,
      flipped_image_filepath: json['flipped_image_filepath'] as String,
      thumbnail_image_filepath: json['thumbnail_image_filepath'] as String,
      name: json['name'] as String,
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
      eventId: json['event_id'] != null ? json['event_id'] as int : null,
    );
  }

  static List<HomeBestFrame> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => HomeBestFrame.fromJson(json)).toList();
  }


}