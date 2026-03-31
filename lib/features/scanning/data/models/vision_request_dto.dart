import 'package:json_annotation/json_annotation.dart';
import 'package:powerocr/features/scanning/data/models/annotate_image_request_dto.dart';
part 'vision_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VisionRequestDto {
  final List<AnnotateImageRequestDto> requests;

  VisionRequestDto({required this.requests});

  factory VisionRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VisionRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VisionRequestDtoToJson(this);
}
