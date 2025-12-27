import 'package:json_annotation/json_annotation.dart';
import '../../enum/enums.dart';

part 'print_queue_item.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PrintQueueResponse {
  final int count;
  final List<PrintQueueItem> items;

  PrintQueueResponse({
    required this.count,
    required this.items,
  });

  factory PrintQueueResponse.fromJson(Map<String, dynamic> json) =>
      _$PrintQueueResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrintQueueResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PrintQueueItem {
  final int id;
  final String imageFilepath;
  final String originalImageFilepath;
  final String thumbnailFilepath;
  final PrintQueueStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? printedAt;
  final PrintQueueMobileUser mobileUser;
  final PrintQueuePrinter printer;
  final PrintQueueEvent event;

  PrintQueueItem({
    required this.id,
    required this.imageFilepath,
    required this.originalImageFilepath,
    required this.thumbnailFilepath,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.printedAt,
    required this.mobileUser,
    required this.printer,
    required this.event,
  });

  factory PrintQueueItem.fromJson(Map<String, dynamic> json) =>
      _$PrintQueueItemFromJson(json);

  Map<String, dynamic> toJson() => _$PrintQueueItemToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PrintQueueMobileUser {
  final int id;
  final String name;
  final String email;
  final String? profileUrl;
  final String phoneNumber;
  final DateTime? phoneNumberVerificationDate;

  PrintQueueMobileUser({
    required this.id,
    required this.name,
    required this.email,
    this.profileUrl,
    required this.phoneNumber,
    this.phoneNumberVerificationDate,
  });

  factory PrintQueueMobileUser.fromJson(Map<String, dynamic> json) =>
      _$PrintQueueMobileUserFromJson(json);

  Map<String, dynamic> toJson() => _$PrintQueueMobileUserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PrintQueuePrinter {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  PrintQueuePrinter({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory PrintQueuePrinter.fromJson(Map<String, dynamic> json) =>
      _$PrintQueuePrinterFromJson(json);

  Map<String, dynamic> toJson() => _$PrintQueuePrinterToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PrintQueueEvent {
  final int id;
  final String name;
  final String thumbnailFilepath;
  final DateTime startDate;
  final DateTime endDate;

  PrintQueueEvent({
    required this.id,
    required this.name,
    required this.thumbnailFilepath,
    required this.startDate,
    required this.endDate,
  });

  factory PrintQueueEvent.fromJson(Map<String, dynamic> json) =>
      _$PrintQueueEventFromJson(json);

  Map<String, dynamic> toJson() => _$PrintQueueEventToJson(this);
}
