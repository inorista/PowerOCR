// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotate_image_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnotateImageRequestDto _$AnnotateImageRequestDtoFromJson(
        Map<String, dynamic> json) =>
    AnnotateImageRequestDto(
      image: VisionImageDto.fromJson(json['image'] as Map<String, dynamic>),
      features: (json['features'] as List<dynamic>)
          .map((e) => VisionFeatureDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnnotateImageRequestDtoToJson(
        AnnotateImageRequestDto instance) =>
    <String, dynamic>{
      'image': instance.image.toJson(),
      'features': instance.features.map((e) => e.toJson()).toList(),
    };
