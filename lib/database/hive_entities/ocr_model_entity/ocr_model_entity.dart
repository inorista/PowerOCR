import 'package:hive_ce/hive_ce.dart';
import 'package:powerocr/database/base_entity.dart';
import 'package:powerocr/database/hive_database.dart' show HiveBoxNums;
part 'ocr_model_entity.g.dart';

@HiveType(typeId: HiveBoxNums.ocrModelEntity)
class OcrModelEntity extends BaseEntity {
  @HiveField(1)
  String model;
  @HiveField(2)
  String language;
  @HiveField(3)
  String languageName;

  OcrModelEntity({
    required this.model,
    required this.language,
    required this.languageName,
  });

  OcrModelEntity copyWith({
    String? model,
    String? language,
    String? languageName,
  }) {
    return OcrModelEntity(
      model: model ?? this.model,
      language: language ?? this.language,
      languageName: languageName ?? this.languageName,
    );
  }
}
