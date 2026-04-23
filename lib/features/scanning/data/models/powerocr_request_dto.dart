import 'package:json_annotation/json_annotation.dart';
part 'powerocr_request_dto.g.dart';

@JsonSerializable()
class PowerOCRRequestDto {
  @JsonKey(name: 'base64_string')
  final String base64String;
  final String lang;

  PowerOCRRequestDto({required this.base64String, required this.lang});

  factory PowerOCRRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PowerOCRRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PowerOCRRequestDtoToJson(this);
}
