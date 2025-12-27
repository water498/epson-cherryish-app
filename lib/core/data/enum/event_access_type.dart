import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum EventAccessType {
  public('PUBLIC'),
  onlyLinkPublic('ONLY_LINK_PUBLIC');

  final String value;
  const EventAccessType(this.value);

  static EventAccessType fromValue(String value) {
    return EventAccessType.values.firstWhere((e) => e.value == value);
  }
}
