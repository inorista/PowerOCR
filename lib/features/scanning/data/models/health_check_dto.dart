import 'package:json_annotation/json_annotation.dart';
part 'health_check_dto.g.dart';

@JsonSerializable()
class HealthCheckDto {
  final String status;
  @JsonKey(name: 'active_engines')
  final List<String> activeEngines;

  HealthCheckDto({required this.status, required this.activeEngines});

  factory HealthCheckDto.fromJson(Map<String, dynamic> json) =>
      _$HealthCheckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HealthCheckDtoToJson(this);
}
