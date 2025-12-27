import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum LanguageType {
  ko('KO'),
  en('EN'),
  ja('JA');

  final String value;
  const LanguageType(this.value);

  static LanguageType fromValue(String value) {
    return LanguageType.values.firstWhere((e) => e.value == value);
  }
}
