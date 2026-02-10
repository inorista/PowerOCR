import 'package:json_annotation/json_annotation.dart';
part 'annotate_image_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VisionApiResponseDto {
  final List<AnnotateImageResponseDto>? responses;

  VisionApiResponseDto({this.responses});

  factory VisionApiResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VisionApiResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VisionApiResponseDtoToJson(this);
}

// -----------------------------------------------------------------------------
// 2. Per-Image Response
// -----------------------------------------------------------------------------
@JsonSerializable(explicitToJson: true)
class AnnotateImageResponseDto {
  final List<EntityAnnotationDto>? labelAnnotations;
  final List<EntityAnnotationDto>? textAnnotations;
  final List<EntityAnnotationDto>? landmarkAnnotations;
  final List<EntityAnnotationDto>? logoAnnotations;
  final List<FaceAnnotationDto>? faceAnnotations;
  final Status? error;

  AnnotateImageResponseDto({
    this.labelAnnotations,
    this.textAnnotations,
    this.landmarkAnnotations,
    this.logoAnnotations,
    this.faceAnnotations,
    this.error,
  });

  factory AnnotateImageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AnnotateImageResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AnnotateImageResponseDtoToJson(this);

  String get fullText => textAnnotations?.firstOrNull?.description ?? '';
}

// -----------------------------------------------------------------------------
// 3. Common Entity (Dùng chung cho Label, Text, Landmark, Logo)
// -----------------------------------------------------------------------------
@JsonSerializable(explicitToJson: true)
class EntityAnnotationDto {
  final String? mid;
  final String? description;
  final double? score;
  final double? topicality;
  final BoundingPolyDto? boundingPoly;

  EntityAnnotationDto({
    this.mid,
    this.description,
    this.score,
    this.topicality,
    this.boundingPoly,
  });

  factory EntityAnnotationDto.fromJson(Map<String, dynamic> json) =>
      _$EntityAnnotationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$EntityAnnotationDtoToJson(this);
}

// -----------------------------------------------------------------------------
// 4. Face Annotation (Cấu trúc riêng cho Face)
// -----------------------------------------------------------------------------
@JsonSerializable(explicitToJson: true)
class FaceAnnotationDto {
  final BoundingPolyDto? boundingPoly;
  final double? detectionConfidence;
  final double? landMarkingConfidence;

  // Các thuộc tính cảm xúc (Likelihood Strings: VERY_LIKELY, UNLIKELY...)
  final String? joyLikelihood;
  final String? sorrowLikelihood;
  final String? angerLikelihood;
  final String? surpriseLikelihood;
  final String? headwearLikelihood;

  FaceAnnotationDto({
    this.boundingPoly,
    this.detectionConfidence,
    this.landMarkingConfidence,
    this.joyLikelihood,
    this.sorrowLikelihood,
    this.angerLikelihood,
    this.surpriseLikelihood,
    this.headwearLikelihood,
  });

  factory FaceAnnotationDto.fromJson(Map<String, dynamic> json) =>
      _$FaceAnnotationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FaceAnnotationDtoToJson(this);
}

// -----------------------------------------------------------------------------
// 5. Geometry Helpers (Bounding Box)
// -----------------------------------------------------------------------------
@JsonSerializable(explicitToJson: true)
class BoundingPolyDto {
  final List<VertexDto>? vertices;

  BoundingPolyDto({this.vertices});

  factory BoundingPolyDto.fromJson(Map<String, dynamic> json) =>
      _$BoundingPolyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BoundingPolyDtoToJson(this);
}

@JsonSerializable()
class VertexDto {
  final int? x;
  final int? y;

  VertexDto({this.x, this.y});

  factory VertexDto.fromJson(Map<String, dynamic> json) =>
      _$VertexDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VertexDtoToJson(this);
}

// -----------------------------------------------------------------------------
// 6. Error Status
// -----------------------------------------------------------------------------
@JsonSerializable()
class Status {
  final int? code;
  final String? message;

  Status({this.code, this.message});

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}
