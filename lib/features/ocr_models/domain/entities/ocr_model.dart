import 'package:powerocr/database/hive_entities/ocr_model_entity/ocr_model_entity.dart';

class OcrModel {
  final String model;
  final String language;
  final String languageName;

  const OcrModel({
    required this.model,
    required this.language,
    required this.languageName,
  });

  // copyWith method
  OcrModel copyWith({String? model, String? language, String? languageName}) {
    return OcrModel(
      model: model ?? this.model,
      language: language ?? this.language,
      languageName: languageName ?? this.languageName,
    );
  }

  factory OcrModel.fromEntity(OcrModelEntity entity) {
    return OcrModel(
      model: entity.model,
      language: entity.language,
      languageName: entity.languageName,
    );
  }
}
