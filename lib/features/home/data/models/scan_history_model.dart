import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart';
import 'package:powerocr/features/home/domain/entities/scan_history.dart';

class ScanHistoryModel extends ScanHistory {
  ScanHistoryModel({
    required super.id,
    required super.imagePath,
    required super.text,
    required super.createdAt,
    required super.type,
  });

  factory ScanHistoryModel.fromHive(ScanHistoryEntity entity) {
    return ScanHistoryModel(
      id: entity.id,
      imagePath: entity.imagePath,
      text: entity.text,
      createdAt: entity.createdAt,
      type: entity.type,
    );
  }

  static List<ScanHistoryModel> fromHiveList(List<ScanHistoryEntity> entities) {
    return entities.map((e) => ScanHistoryModel.fromHive(e)).toList();
  }
}
