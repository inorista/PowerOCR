// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OcrModelDto _$OcrModelDtoFromJson(Map<String, dynamic> json) => OcrModelDto(
  model: json['model'] as String,
  language: json['language'] as String,
  languageName: json['language_name'] as String,
);

Map<String, dynamic> _$OcrModelDtoToJson(OcrModelDto instance) =>
    <String, dynamic>{
      'model': instance.model,
      'language': instance.language,
      'language_name': instance.languageName,
    };
