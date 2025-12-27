// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qna.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Qna _$QnaFromJson(Map<String, dynamic> json) => Qna(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      answer: json['answer'] as String,
      isShow: json['is_show'] as bool,
      lang: $enumDecode(_$LanguageTypeEnumMap, json['lang']),
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
      deletedDate: json['deleted_date'] == null
          ? null
          : DateTime.parse(json['deleted_date'] as String),
    );

Map<String, dynamic> _$QnaToJson(Qna instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'answer': instance.answer,
      'is_show': instance.isShow,
      'lang': _$LanguageTypeEnumMap[instance.lang]!,
      'created_date': instance.createdDate.toIso8601String(),
      'updated_date': instance.updatedDate.toIso8601String(),
      'deleted_date': instance.deletedDate?.toIso8601String(),
    };

const _$LanguageTypeEnumMap = {
  LanguageType.ko: 'KO',
  LanguageType.en: 'EN',
  LanguageType.ja: 'JA',
};
