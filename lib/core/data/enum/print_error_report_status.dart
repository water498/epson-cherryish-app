import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum PrintErrorReportStatus {
  pending('PENDING'),
  rejected('REJECTED'),
  refunded('REFUNDED');

  final String value;
  const PrintErrorReportStatus(this.value);

  static PrintErrorReportStatus fromValue(String value) {
    return PrintErrorReportStatus.values.firstWhere((e) => e.value == value);
  }
}
