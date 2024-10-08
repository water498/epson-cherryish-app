class TempEventFrame {


  final String uid;
  final bool isShow;
  final String originalImageFilepath;
  final String previewImageFilepath;
  final String name;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int eventId;

  final int width,height;

  TempEventFrame({
    required this.uid,
    required this.isShow,
    required this.originalImageFilepath,
    required this.previewImageFilepath,
    required this.name,
    required this.createdDate,
    required this.updatedDate,
    required this.eventId,
    required this.width,
    required this.height,
  });

  // fromJson method
  factory TempEventFrame.fromJson(Map<String, dynamic> json) {
    return TempEventFrame(
      uid: json['uid'] as String,
      isShow: json['is_show'] as bool,
      originalImageFilepath: json['original_image_filepath'] as String,
      previewImageFilepath: json['preview_image_filepath'] as String,
      name: json['name'] as String,
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: DateTime.parse(json['updated_date']),
      eventId: json['event_id'] as int,

      width: json['width'] as int,
      height: json['height'] as int,
    );
  }


  static List<Map<String,dynamic>> dummy_data = [
    {
      "uid": "frame01",
      "is_show": true,
      "original_image_filepath": "/test/original01.png",
      "preview_image_filepath": "/test/preview01.png",
      "name": "New Waves, New Ways",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame02",
      "is_show": true,
      "original_image_filepath": "/test/original02.png",
      "preview_image_filepath": "/test/preview02.png",
      "name": "Dear Jeff",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 2,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame03",
      "is_show": true,
      "original_image_filepath": "/test/original03.png",
      "preview_image_filepath": "/test/preview03.png",
      "name": "웰컴 구디백",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 3,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame04",
      "is_show": true,
      "original_image_filepath": "/test/original04.png",
      "preview_image_filepath": "/test/preview04.png",
      "name": "Fragile Glass",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 4,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame05",
      "is_show": true,
      "original_image_filepath": "/test/original05.png",
      "preview_image_filepath": "/test/preview05.png",
      "name": "Pizza exile",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 5,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame06",
      "is_show": true,
      "original_image_filepath": "/test/original06.png",
      "preview_image_filepath": "/test/preview06.png",
      "name": "첫번째 생일",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 6,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame07",
      "is_show": true,
      "original_image_filepath": "/test/original07.png",
      "preview_image_filepath": "/test/preview07.png",
      "name": "웰컴 투 유니버스",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 7,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame08",
      "is_show": true,
      "original_image_filepath": "/test/original08.png",
      "preview_image_filepath": "/test/preview08.png",
      "name": "슬로우텅",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 8,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame09",
      "is_show": true,
      "original_image_filepath": "/test/original09.png",
      "preview_image_filepath": "/test/preview09.png",
      "name": "우주로부터의 시야",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame10",
      "is_show": true,
      "original_image_filepath": "/test/original10.png",
      "preview_image_filepath": "/test/preview10.png",
      "name": "시작하는 곳의 시야",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame11",
      "is_show": true,
      "original_image_filepath": "/test/original11.png",
      "preview_image_filepath": "/test/preview11.png",
      "name": "사랑의 하츄핑",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame12",
      "is_show": true,
      "original_image_filepath": "/test/original12.png",
      "preview_image_filepath": "/test/preview12.png",
      "name": "HibiscusBloom",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame13",
      "is_show": true,
      "original_image_filepath": "/test/original13.png",
      "preview_image_filepath": "/test/preview13.png",
      "name": "시야 프레임 13",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame14",
      "is_show": true,
      "original_image_filepath": "/test/original14.png",
      "preview_image_filepath": "/test/preview14.png",
      "name": "시야 프레임 14",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame15",
      "is_show": true,
      "original_image_filepath": "/test/original15.png",
      "preview_image_filepath": "/test/preview15.png",
      "name": "시야 프레임 15",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    },
    {
      "uid": "frame16",
      "is_show": true,
      "original_image_filepath": "/test/original15.png",
      "preview_image_filepath": "/test/preview15.png",
      "name": "시야 프레임 16",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "event_id": 1,
      "width" : 1920,
      "height" : 2880,
    }
  ];

}