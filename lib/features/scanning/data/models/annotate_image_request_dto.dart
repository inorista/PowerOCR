import 'package:json_annotation/json_annotation.dart';
import 'package:powerocr/features/scanning/data/models/vision_feature_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_image_dto.dart';
part 'annotate_image_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AnnotateImageRequestDto {
  final VisionImageDto image;
  final List<VisionFeatureDto> features;

  AnnotateImageRequestDto({required this.image, required this.features});

  factory AnnotateImageRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AnnotateImageRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AnnotateImageRequestDtoToJson(this);
}
