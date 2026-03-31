import 'package:json_annotation/json_annotation.dart';
import 'package:powerocr/core/constants/enum.dart';
part 'vision_feature_dto.g.dart';

@JsonSerializable()
class VisionFeatureDto {
  final VisionFeatureType type;
  final int maxResults;

  VisionFeatureDto({required this.type, this.maxResults = 10});

  factory VisionFeatureDto.fromJson(Map<String, dynamic> json) =>
      _$VisionFeatureDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VisionFeatureDtoToJson(this);
}
