class TempHomeBestFrame {

  String uid;
  bool isShow;
  String previewImageFilepath;
  String flippedImageFilepath;
  String thumbnailImageFilepath;
  String name;
  DateTime createdDate;
  DateTime updatedDate;
  int? eventId;

  TempHomeBestFrame({
    required this.uid,
    required this.isShow,
    required this.previewImageFilepath,
    required this.flippedImageFilepath,
    required this.thumbnailImageFilepath,
    required this.name,
    required this.createdDate,
    required this.updatedDate,
    this.eventId,
  });

  // From JSON method
  factory TempHomeBestFrame.fromJson(Map<String, dynamic> json) {
    return TempHomeBestFrame(
      uid: json['uid'] as String,
      isShow: json['is_show'] as bool,
      previewImageFilepath: json['preview_image_filepath'] as String,
      flippedImageFilepath: json['flipped_image_filepath'] as String,
      thumbnailImageFilepath: json['thumbnail_image_filepath'] as String,
      name: json['name'] as String,
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
      eventId: json['event_id'] != null ? json['event_id'] as int : null,
    );
  }

  static List<Map<String, dynamic>> dummy_data = [
    {
      "uid": "best_frame01",
      "is_show": true,
      "preview_image_filepath": "/test/preview01.png",
      "flipped_image_filepath": "/test/flipped01.png",
      "thumbnail_image_filepath": "/test/thumbnail01.png",
      "name": "Best Frame 1",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1
    },
    {
      "uid": "best_frame02",
      "is_show": true,
      "preview_image_filepath": "/test/preview02.png",
      "flipped_image_filepath": "/test/flipped02.png",
      "thumbnail_image_filepath": "/test/thumbnail02.png",
      "name": "Best Frame 2",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 2
    },
    {
      "uid": "best_frame03",
      "is_show": true,
      "preview_image_filepath": "/test/preview03.png",
      "flipped_image_filepath": "/test/flipped03.png",
      "thumbnail_image_filepath": "/test/thumbnail03.png",
      "name": "Best Frame 3",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 3
    },
    {
      "uid": "best_frame04",
      "is_show": true,
      "preview_image_filepath": "/test/preview04.png",
      "flipped_image_filepath": "/test/flipped04.png",
      "thumbnail_image_filepath": "/test/thumbnail04.png",
      "name": "Best Frame 4",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 4
    },
    {
      "uid": "best_frame05",
      "is_show": true,
      "preview_image_filepath": "/test/preview05.png",
      "flipped_image_filepath": "/test/flipped05.png",
      "thumbnail_image_filepath": "/test/thumbnail05.png",
      "name": "Best Frame 5",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 5
    },
    {
      "uid": "best_frame06",
      "is_show": true,
      "preview_image_filepath": "/test/preview06.png",
      "flipped_image_filepath": "/test/flipped06.png",
      "thumbnail_image_filepath": "/test/thumbnail06.png",
      "name": "Best Frame 6",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 6
    },
    {
      "uid": "best_frame07",
      "is_show": true,
      "preview_image_filepath": "/test/preview07.png",
      "flipped_image_filepath": "/test/flipped07.png",
      "thumbnail_image_filepath": "/test/thumbnail07.png",
      "name": "Best Frame 7",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 7
    },
    {
      "uid": "best_frame08",
      "is_show": true,
      "preview_image_filepath": "/test/preview08.png",
      "flipped_image_filepath": "/test/flipped08.png",
      "thumbnail_image_filepath": "/test/thumbnail08.png",
      "name": "Best Frame 8",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 8
    },
  ];

}