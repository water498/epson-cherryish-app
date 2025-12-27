import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum PrintQueueStatus {
  none('NONE'),
  wait('WAIT'),
  printing('PRINTING'),
  completed('COMPLETED'),
  error('ERROR');

  final String value;
  const PrintQueueStatus(this.value);

  static PrintQueueStatus fromValue(String value) {
    return PrintQueueStatus.values.firstWhere((e) => e.value == value);
  }
}
