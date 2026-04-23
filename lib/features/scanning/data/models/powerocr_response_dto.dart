import 'package:json_annotation/json_annotation.dart';
import 'package:powerocr/features/scanning/data/models/datum_response_dto.dart';
part 'powerocr_response_dto.g.dart';

@JsonSerializable()
class PowerOCRResponseDto {
  final String status;
  final String engine;
  @JsonKey(name: 'total_text')
  final String totalText;
  final List<DatumResponseDto> data;

  PowerOCRResponseDto({
    required this.status,
    required this.engine,
    required this.totalText,
    required this.data,
  });

  factory PowerOCRResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PowerOCRResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PowerOCRResponseDtoToJson(this);
}
