import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum EditorFrameType {
  typeA('TYPE_A'),
  typeB('TYPE_B'),
  typeC('TYPE_C'),
  typeD('TYPE_D'),
  typeE('TYPE_E');

  final String value;
  const EditorFrameType(this.value);

  static EditorFrameType fromValue(String value) {
    return EditorFrameType.values.firstWhere((e) => e.value == value);
  }
}
