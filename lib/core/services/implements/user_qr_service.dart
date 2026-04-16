import 'package:injectable/injectable.dart';
import 'package:powerocr/core/services/interfaces/iuser_qr_service.dart';
import 'package:powerocr/database/hive_daos/user_qr_dao.dart';
import 'package:powerocr/database/hive_entities/user_qr_entity/user_qr_entity.dart';

@LazySingleton(as: IUserQrService)
class UserQrService implements IUserQrService {
  final UserQrDao _userQrDao;

  UserQrService(this._userQrDao);

  @override
  Future<void> saveUserQr(UserQrEntity userQr) {
    return _userQrDao.update(userQr.id, userQr);
  }

  @override
  Future<List<UserQrEntity>> getUserQrs() {
    return _userQrDao.getAll();
  }

  @override
  Future<void> deleteUserQr(String id) {
    return _userQrDao.delete(id);
  }
}
