import 'package:injectable/injectable.dart' show LazySingleton;
import 'package:powerocr/core/di/locator.dart' show locator;
import 'package:powerocr/database/hive_daos/ocr_model_dao.dart'
    show OcrModelDao;
import 'package:powerocr/features/ocr_models/data/models/ocr_model_dto.dart';
import 'package:powerocr/features/ocr_models/domain/entities/ocr_model.dart';

abstract class OcrModelLocalDataSource {
  Future<List<OcrModel>> getOcrModels();
  Future<void> saveOcrModels(List<OcrModelDto> ocrModelDtos);
  Future<void> deleteOcrModel(String id);
  Future<void> clearOcrModels();
}

@LazySingleton(as: OcrModelLocalDataSource)
class OcrModelLocalDataSourceImpl implements OcrModelLocalDataSource {
  final OcrModelDao _ocrModelDao = locator<OcrModelDao>();

  @override
  Future<void> deleteOcrModel(String id) async {
    return await _ocrModelDao.delete(id);
  }

  @override
  Future<void> clearOcrModels() async {
    return await _ocrModelDao.clear();
  }

  @override
  Future<List<OcrModel>> getOcrModels() async {
    return await _ocrModelDao.getAll().then((entities) {
      return entities.map((entity) => OcrModel.fromEntity(entity)).toList();
    });
  }

  @override
  Future<void> saveOcrModels(List<OcrModelDto> ocrModelDtos) async {
    final entites = ocrModelDtos.map((e) => e.toEntity()).toList();
    await _ocrModelDao.updateAll({for (var item in entites) item.id: item});
  }
}
