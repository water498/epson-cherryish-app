class TempEventFilter {


  final String uid;
  final String? imageFilepath;
  final String name;
  final DateTime createdDate;
  final DateTime updatedDate;
  final String eventFrameUid;

  final int x,y,width,height;

  TempEventFilter({
    required this.uid,
    this.imageFilepath,
    required this.name,
    required this.createdDate,
    required this.updatedDate,
    required this.eventFrameUid,

    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  // fromJson method
  factory TempEventFilter.fromJson(Map<String, dynamic> json) {
    return TempEventFilter(
      uid: json['uid'] as String,
      imageFilepath: json['image_filepath'] as String?,
      name: json['name'] as String,
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: DateTime.parse(json['updated_date']),
      eventFrameUid: json['evnet_frame_uid'] as String,

      x: json['x'] as int,
      y: json['y'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
    );
  }


  static List<Map<String,dynamic>> dummy_data = [
    {
      "uid": "frame01_filter01",
      "image_filepath": null,
      "name": "type_c",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame01",
      "x" : 134,
      "y" : 460,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame01_filter02",
      "image_filepath": null,
      "name": "type_c",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame01",
      "x" : 134,
      "y" : 1586,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame01_filter03",
      "image_filepath": null,
      "name": "type_c",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame01",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame01_filter04",
      "image_filepath": null,
      "name": "type_c",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame01",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame02_filter01",
      "image_filepath": null,
      "name": "type_d",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame02",
      "x" : 134,
      "y" : 460,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame02_filter02",
      "image_filepath": null,
      "name": "type_d",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame02",
      "x" : 134,
      "y" : 1586,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame02_filter03",
      "image_filepath": null,
      "name": "type_d",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame02",
      "x" : 1000,
      "y" : 460,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame02_filter04",
      "image_filepath": null,
      "name": "type_d",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame02",
      "x" : 1000,
      "y" : 1586,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame03_filter01",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame03",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame03_filter02",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame03",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame03_filter03",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame03",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame03_filter04",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame03",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame04_filter01",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame04",
      "x" : 134,
      "y" : 344,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame04_filter02",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame04",
      "x" : 134,
      "y" : 1470,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame04_filter03",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame04",
      "x" : 1000,
      "y" : 344,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame04_filter04",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame04",
      "x" : 1000,
      "y" : 1470,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame05_filter01",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame05",
      "x" : 134,
      "y" : 344,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame05_filter02",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame05",
      "x" : 134,
      "y" : 1470,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame05_filter03",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame05",
      "x" : 1000,
      "y" : 344,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame05_filter04",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame05",
      "x" : 1000,
      "y" : 1470,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame06_filter01",
      "image_filepath": null,
      "name": "type_c",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame06",
      "x" : 134,
      "y" : 460,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame06_filter02",
      "image_filepath": null,
      "name": "type_c",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame06",
      "x" : 134,
      "y" : 1586,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame06_filter03",
      "image_filepath": null,
      "name": "type_c",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame06",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame06_filter04",
      "image_filepath": null,
      "name": "type_c",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame06",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame07_filter01",
      "image_filepath": null,
      "name": "type_b",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame07",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame07_filter02",
      "image_filepath": null,
      "name": "type_b",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame07",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame07_filter03",
      "image_filepath": null,
      "name": "type_b",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame07",
      "x" : 1000,
      "y" : 460,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame07_filter04",
      "image_filepath": null,
      "name": "type_b",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame07",
      "x" : 1000,
      "y" : 1586,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame08_filter01",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame08",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame08_filter02",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame08",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame08_filter03",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame08",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame08_filter04",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame08",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame09_filter01",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame09",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame09_filter02",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame09",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame09_filter03",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame09",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame09_filter04",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame09",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame10_filter01",
      "image_filepath": "/test/frame10_filter01.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame10",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame10_filter02",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame10",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame10_filter03",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame10",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame10_filter04",
      "image_filepath": null,
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame10",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame11_filter01",
      "image_filepath": "/test/frame11_filter01.png",
      "name": "type_b",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame11",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame11_filter02",
      "image_filepath": "/test/frame11_filter02.png",
      "name": "type_b",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame11",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame11_filter03",
      "image_filepath": "/test/frame11_filter03.png",
      "name": "type_b",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame11",
      "x" : 1000,
      "y" : 460,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame11_filter04",
      "image_filepath": "/test/frame11_filter04.png",
      "name": "type_b",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame11",
      "x" : 1000,
      "y" : 1586,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame12_filter01",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame12",
      "x" : 134,
      "y" : 344,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame12_filter02",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame12",
      "x" : 134,
      "y" : 1470,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame12_filter03",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame12",
      "x" : 1000,
      "y" : 344,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame12_filter04",
      "image_filepath": null,
      "name": "type_e",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame12",
      "x" : 1000,
      "y" : 1470,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame13_filter01",
      "image_filepath": "/test/frame13_filter01.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame13",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame13_filter02",
      "image_filepath": "/test/frame13_filter02.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame13",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame13_filter03",
      "image_filepath": "/test/frame13_filter03.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame13",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame13_filter04",
      "image_filepath": "/test/frame13_filter04.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame13",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame14_filter01",
      "image_filepath": "/test/frame14_filter01.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame14",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame14_filter02",
      "image_filepath": "/test/frame14_filter02.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame14",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame14_filter03",
      "image_filepath": "/test/frame14_filter03.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame14",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame14_filter04",
      "image_filepath": "/test/frame14_filter04.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame14",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame15_filter01",
      "image_filepath": "/test/frame15_filter01.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame15",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame15_filter02",
      "image_filepath": "/test/frame15_filter02.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame15",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame15_filter03",
      "image_filepath": "/test/frame15_filter03.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame15",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame15_filter04",
      "image_filepath": "/test/frame15_filter04.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame15",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame16_filter01",
      "image_filepath": "/test/frame16_filter01.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame16",
      "x" : 134,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame16_filter02",
      "image_filepath": "/test/frame16_filter02.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame16",
      "x" : 134,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame16_filter03",
      "image_filepath": "/test/frame16_filter03.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame16",
      "x" : 1000,
      "y" : 230,
      "width" : 786,
      "height" : 1064,
    },
    {
      "uid": "frame16_filter04",
      "image_filepath": "/test/frame16_filter04.png",
      "name": "type_a",
      "created_date": "2024-09-10T10:30:00",
      "updated_date": "2024-09-11T15:45:00",
      "evnet_frame_uid": "frame16",
      "x" : 1000,
      "y" : 1356,
      "width" : 786,
      "height" : 1064,
    }
  ];

}