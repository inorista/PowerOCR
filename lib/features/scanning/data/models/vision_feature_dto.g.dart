// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vision_feature_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisionFeatureDto _$VisionFeatureDtoFromJson(Map<String, dynamic> json) =>
    VisionFeatureDto(
      type: $enumDecode(_$VisionFeatureTypeEnumMap, json['type']),
      maxResults: (json['maxResults'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$VisionFeatureDtoToJson(VisionFeatureDto instance) =>
    <String, dynamic>{
      'type': _$VisionFeatureTypeEnumMap[instance.type]!,
      'maxResults': instance.maxResults,
    };

const _$VisionFeatureTypeEnumMap = {
  VisionFeatureType.typeUnspecified: 'TYPE_UNSPECIFIED',
  VisionFeatureType.faceDetection: 'FACE_DETECTION',
  VisionFeatureType.landmarkDetection: 'LANDMARK_DETECTION',
  VisionFeatureType.logoDetection: 'LOGO_DETECTION',
  VisionFeatureType.labelDetection: 'LABEL_DETECTION',
  VisionFeatureType.textDetection: 'TEXT_DETECTION',
  VisionFeatureType.documentTextDetection: 'DOCUMENT_TEXT_DETECTION',
  VisionFeatureType.safeSearchDetection: 'SAFE_SEARCH_DETECTION',
  VisionFeatureType.imageProperties: 'IMAGE_PROPERTIES',
  VisionFeatureType.cropHints: 'CROP_HINTS',
  VisionFeatureType.webDetection: 'WEB_DETECTION',
};
