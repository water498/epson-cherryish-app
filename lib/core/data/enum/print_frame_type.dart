import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum PrintFrameType {
  ltRtLbRb('lt_rt_lb_rb'),
  ltRt('lt_rt'),
  lbRb('lb_rb'),
  singleTop('single_top'),
  singleBottom('single_bottom');

  final String value;
  const PrintFrameType(this.value);

  static PrintFrameType fromValue(String value) {
    return PrintFrameType.values.firstWhere((e) => e.value == value);
  }
}
