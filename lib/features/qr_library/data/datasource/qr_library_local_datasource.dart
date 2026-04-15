import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/database/hive_daos/user_qr_dao.dart';
import 'package:powerocr/database/hive_entities/user_qr_entity/user_qr_entity.dart';
import 'package:powerocr/features/qr_library/data/models/user_qr_model.dart';

abstract class QrLibraryLocalDataSource {
  Future<List<UserQrModel>> getUserQrs();
  Future<void> saveUserQr(UserQrModel userQrModel);
  Future<void> deleteUserQr(String id);
}

@LazySingleton(as: QrLibraryLocalDataSource)
class QrLibraryLocalDataSourceImpl implements QrLibraryLocalDataSource {
  final UserQrDao _userQrDao = locator<UserQrDao>();

  @override
  Future<List<UserQrModel>> getUserQrs() async {
    final entities = await _userQrDao.getAll();
    try {
      final docDir = await getApplicationDocumentsDirectory();
      for (var entity in entities) {
        if (entity.imagePath.isNotEmpty) {
          if (!entity.imagePath.contains('/')) {
            entity.imagePath = '${docDir.path}/${entity.imagePath}';
          } else if (entity.imagePath.contains('/Documents/')) {
            final parts = entity.imagePath.split('/Documents/');
            if (parts.length > 1) {
              entity.imagePath = '${docDir.path}/${parts.last}';
            }
          }
        }
      }
    } catch (e) {
      // Ignore if document directory access fails
    }
    return entities.map((e) => UserQrModel.fromEntity(e)).toList();
  }

  @override
  Future<void> saveUserQr(UserQrModel userQrModel) async {
    await _userQrDao.update(userQrModel.id, userQrModel.toEntity());
  }

  @override
  Future<void> deleteUserQr(String id) async {
    await _userQrDao.delete(id);
  }
}
