import 'package:json_annotation/json_annotation.dart';
part 'vision_image_dto.g.dart';

@JsonSerializable()
class VisionImageDto {
  final String content;

  VisionImageDto({required this.content});

  factory VisionImageDto.fromJson(Map<String, dynamic> json) =>
      _$VisionImageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VisionImageDtoToJson(this);
}
