// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotate_image_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisionApiResponseDto _$VisionApiResponseDtoFromJson(
  Map<String, dynamic> json,
) => VisionApiResponseDto(
  responses: (json['responses'] as List<dynamic>?)
      ?.map((e) => AnnotateImageResponseDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VisionApiResponseDtoToJson(
  VisionApiResponseDto instance,
) => <String, dynamic>{
  'responses': instance.responses?.map((e) => e.toJson()).toList(),
};

AnnotateImageResponseDto _$AnnotateImageResponseDtoFromJson(
  Map<String, dynamic> json,
) => AnnotateImageResponseDto(
  labelAnnotations: (json['labelAnnotations'] as List<dynamic>?)
      ?.map((e) => EntityAnnotationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  textAnnotations: (json['textAnnotations'] as List<dynamic>?)
      ?.map((e) => EntityAnnotationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  landmarkAnnotations: (json['landmarkAnnotations'] as List<dynamic>?)
      ?.map((e) => EntityAnnotationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  logoAnnotations: (json['logoAnnotations'] as List<dynamic>?)
      ?.map((e) => EntityAnnotationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  faceAnnotations: (json['faceAnnotations'] as List<dynamic>?)
      ?.map((e) => FaceAnnotationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  error: json['error'] == null
      ? null
      : Status.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnnotateImageResponseDtoToJson(
  AnnotateImageResponseDto instance,
) => <String, dynamic>{
  'labelAnnotations': instance.labelAnnotations
      ?.map((e) => e.toJson())
      .toList(),
  'textAnnotations': instance.textAnnotations?.map((e) => e.toJson()).toList(),
  'landmarkAnnotations': instance.landmarkAnnotations
      ?.map((e) => e.toJson())
      .toList(),
  'logoAnnotations': instance.logoAnnotations?.map((e) => e.toJson()).toList(),
  'faceAnnotations': instance.faceAnnotations?.map((e) => e.toJson()).toList(),
  'error': instance.error?.toJson(),
};

EntityAnnotationDto _$EntityAnnotationDtoFromJson(Map<String, dynamic> json) =>
    EntityAnnotationDto(
      mid: json['mid'] as String?,
      description: json['description'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      topicality: (json['topicality'] as num?)?.toDouble(),
      boundingPoly: json['boundingPoly'] == null
          ? null
          : BoundingPolyDto.fromJson(
              json['boundingPoly'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$EntityAnnotationDtoToJson(
  EntityAnnotationDto instance,
) => <String, dynamic>{
  'mid': instance.mid,
  'description': instance.description,
  'score': instance.score,
  'topicality': instance.topicality,
  'boundingPoly': instance.boundingPoly?.toJson(),
};

FaceAnnotationDto _$FaceAnnotationDtoFromJson(
  Map<String, dynamic> json,
) => FaceAnnotationDto(
  boundingPoly: json['boundingPoly'] == null
      ? null
      : BoundingPolyDto.fromJson(json['boundingPoly'] as Map<String, dynamic>),
  detectionConfidence: (json['detectionConfidence'] as num?)?.toDouble(),
  landMarkingConfidence: (json['landMarkingConfidence'] as num?)?.toDouble(),
  joyLikelihood: json['joyLikelihood'] as String?,
  sorrowLikelihood: json['sorrowLikelihood'] as String?,
  angerLikelihood: json['angerLikelihood'] as String?,
  surpriseLikelihood: json['surpriseLikelihood'] as String?,
  headwearLikelihood: json['headwearLikelihood'] as String?,
);

Map<String, dynamic> _$FaceAnnotationDtoToJson(FaceAnnotationDto instance) =>
    <String, dynamic>{
      'boundingPoly': instance.boundingPoly?.toJson(),
      'detectionConfidence': instance.detectionConfidence,
      'landMarkingConfidence': instance.landMarkingConfidence,
      'joyLikelihood': instance.joyLikelihood,
      'sorrowLikelihood': instance.sorrowLikelihood,
      'angerLikelihood': instance.angerLikelihood,
      'surpriseLikelihood': instance.surpriseLikelihood,
      'headwearLikelihood': instance.headwearLikelihood,
    };

BoundingPolyDto _$BoundingPolyDtoFromJson(Map<String, dynamic> json) =>
    BoundingPolyDto(
      vertices: (json['vertices'] as List<dynamic>?)
          ?.map((e) => VertexDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BoundingPolyDtoToJson(BoundingPolyDto instance) =>
    <String, dynamic>{
      'vertices': instance.vertices?.map((e) => e.toJson()).toList(),
    };

VertexDto _$VertexDtoFromJson(Map<String, dynamic> json) =>
    VertexDto(x: (json['x'] as num?)?.toInt(), y: (json['y'] as num?)?.toInt());

Map<String, dynamic> _$VertexDtoToJson(VertexDto instance) => <String, dynamic>{
  'x': instance.x,
  'y': instance.y,
};

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
  code: (json['code'] as num?)?.toInt(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
};
