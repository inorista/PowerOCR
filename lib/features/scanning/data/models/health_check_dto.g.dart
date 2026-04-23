// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_check_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthCheckDto _$HealthCheckDtoFromJson(Map<String, dynamic> json) =>
    HealthCheckDto(
      status: json['status'] as String,
      activeEngines: (json['active_engines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HealthCheckDtoToJson(HealthCheckDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'active_engines': instance.activeEngines,
    };
