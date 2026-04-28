// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatumResponseDto _$DatumResponseDtoFromJson(Map<String, dynamic> json) =>
    DatumResponseDto(
      box: (json['box'] as List<dynamic>)
          .map(
            (e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
          )
          .toList(),
      text: json['text'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$DatumResponseDtoToJson(DatumResponseDto instance) =>
    <String, dynamic>{
      'box': instance.box,
      'text': instance.text,
      'confidence': instance.confidence,
    };
