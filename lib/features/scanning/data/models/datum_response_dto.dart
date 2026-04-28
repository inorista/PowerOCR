import 'package:json_annotation/json_annotation.dart';
part 'datum_response_dto.g.dart';

@JsonSerializable()
class DatumResponseDto {
  final List<List<int>> box;
  final String text;
  final double confidence;

  DatumResponseDto({
    required this.box,
    required this.text,
    required this.confidence,
  });

  factory DatumResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DatumResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DatumResponseDtoToJson(this);
}
