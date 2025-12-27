import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Event {
  final int id;
  final String? eventName;
  final String? mapPinImageFilepath;
  final String? thumbnailImageFilepath;
  final DateTime startDate;
  final DateTime endDate;
  final String address;
  final String addressDetail;
  final bool showAddress;
  final String placeName;
  final double longitude;
  final double latitude;
  final DateTime createdDate;
  final DateTime updatedDate;
  final DateTime? deletedDate;

  Event({
    required this.id,
    this.eventName,
    this.mapPinImageFilepath,
    this.thumbnailImageFilepath,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.addressDetail,
    required this.showAddress,
    required this.placeName,
    required this.longitude,
    required this.latitude,
    required this.createdDate,
    required this.updatedDate,
    this.deletedDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
