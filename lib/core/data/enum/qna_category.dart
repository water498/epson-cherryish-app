import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum QnaCategory {
  general('GENERAL'),
  printer('PRINTER'),
  editor('EDITOR'),
  refund('REFUND');

  final String value;
  const QnaCategory(this.value);

  static QnaCategory fromValue(String value) {
    return QnaCategory.values.firstWhere((e) => e.value == value);
  }
}
