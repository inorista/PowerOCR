// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'powerocr_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PowerOCRRequestDto _$PowerOCRRequestDtoFromJson(Map<String, dynamic> json) =>
    PowerOCRRequestDto(
      base64String: json['base64_string'] as String,
      lang: json['lang'] as String,
    );

Map<String, dynamic> _$PowerOCRRequestDtoToJson(PowerOCRRequestDto instance) =>
    <String, dynamic>{
      'base64_string': instance.base64String,
      'lang': instance.lang,
    };
