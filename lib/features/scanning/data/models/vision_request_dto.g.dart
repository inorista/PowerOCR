// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vision_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisionRequestDto _$VisionRequestDtoFromJson(Map<String, dynamic> json) =>
    VisionRequestDto(
      requests: (json['requests'] as List<dynamic>)
          .map(
            (e) => AnnotateImageRequestDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$VisionRequestDtoToJson(VisionRequestDto instance) =>
    <String, dynamic>{
      'requests': instance.requests.map((e) => e.toJson()).toList(),
    };
