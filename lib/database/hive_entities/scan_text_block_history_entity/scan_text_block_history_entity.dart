import 'package:hive_ce/hive.dart';
import 'package:powerocr/database/base_entity.dart';
import 'package:powerocr/database/hive_database.dart';

part 'scan_text_block_history_entity.g.dart';

@HiveType(typeId: HiveBoxNums.scanTextBlockHistoryEntity)
class ScanTextBlockHistoryEntity extends BaseEntity {
  @HiveField(1)
  final String text;
  @HiveField(2)
  final List<double> boundingBox;
  @HiveField(3)
  final String scanHistoryId;
  ScanTextBlockHistoryEntity({
    super.id,
    required this.text,
    required this.boundingBox,
    required this.scanHistoryId,
  });
}
