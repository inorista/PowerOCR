import 'package:hive_ce/hive.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/database/base_entity.dart';
import 'package:powerocr/database/hive_database.dart';

part 'scan_history_entity.g.dart';

@HiveType(typeId: HiveBoxNums.scanHistoryEntity)
class ScanHistoryEntity extends BaseEntity {
  @HiveField(1)
  String imagePath;
  @HiveField(2)
  String text;
  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  ScanHistoryType? type;
  @HiveField(5)
  int? imageWidth;
  @HiveField(6)
  int? imageHeight;

  ScanHistoryEntity({
    super.id,
    required this.imagePath,
    required this.text,
    required this.createdAt,
    this.imageWidth,
    this.imageHeight,
    this.type = ScanHistoryType.document,
  });
}
