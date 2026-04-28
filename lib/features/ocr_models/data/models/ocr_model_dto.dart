import 'package:json_annotation/json_annotation.dart';
import 'package:powerocr/database/hive_entities/ocr_model_entity/ocr_model_entity.dart';

part 'ocr_model_dto.g.dart';

@JsonSerializable()
class OcrModelDto {
  final String model;
  final String language;
  @JsonKey(name: 'language_name')
  final String languageName;
  const OcrModelDto({
    required this.model,
    required this.language,
    required this.languageName,
  });

  factory OcrModelDto.fromJson(Map<String, dynamic> json) =>
      _$OcrModelDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OcrModelDtoToJson(this);

  OcrModelEntity toEntity() {
    return OcrModelEntity(
      model: model,
      language: language,
      languageName: languageName,
    );
  }

  factory OcrModelDto.fromEntity(OcrModelEntity entity) {
    return OcrModelDto(
      model: entity.model,
      language: entity.language,
      languageName: entity.languageName,
    );
  }

  // copyWith method
  OcrModelDto copyWith({
    String? model,
    String? language,
    String? languageName,
  }) {
    return OcrModelDto(
      model: model ?? this.model,
      language: language ?? this.language,
      languageName: languageName ?? this.languageName,
    );
  }
}
