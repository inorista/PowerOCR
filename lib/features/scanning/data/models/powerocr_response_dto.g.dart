// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'powerocr_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PowerOCRResponseDto _$PowerOCRResponseDtoFromJson(Map<String, dynamic> json) =>
    PowerOCRResponseDto(
      status: json['status'] as String,
      engine: json['engine'] as String,
      totalText: json['total_text'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => DatumResponseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PowerOCRResponseDtoToJson(
  PowerOCRResponseDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'engine': instance.engine,
  'total_text': instance.totalText,
  'data': instance.data,
};
