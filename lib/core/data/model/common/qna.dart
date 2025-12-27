import 'package:json_annotation/json_annotation.dart';
import '../../enum/enums.dart';

part 'qna.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Qna {
  final int id;
  final String title;
  final String answer;
  final bool isShow;
  final LanguageType lang;
  final DateTime createdDate;
  final DateTime updatedDate;
  final DateTime? deletedDate;

  Qna({
    required this.id,
    required this.title,
    required this.answer,
    required this.isShow,
    required this.lang,
    required this.createdDate,
    required this.updatedDate,
    this.deletedDate,
  });

  factory Qna.fromJson(Map<String, dynamic> json) =>
      _$QnaFromJson(json);

  Map<String, dynamic> toJson() => _$QnaToJson(this);
}
