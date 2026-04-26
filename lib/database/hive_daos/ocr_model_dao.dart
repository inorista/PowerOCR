import 'package:injectable/injectable.dart';
import 'package:powerocr/database/hive_daos/base_dao.dart';
import 'package:powerocr/database/hive_database.dart' show HiveBoxIds;
import 'package:powerocr/database/hive_entities/ocr_model_entity/ocr_model_entity.dart'
    show OcrModelEntity;

@lazySingleton
class OcrModelDao extends BaseDao<OcrModelEntity> {
  OcrModelDao() : super(HiveBoxIds.ocrModelEntity);
}
