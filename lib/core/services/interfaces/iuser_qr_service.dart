import 'package:powerocr/database/hive_entities/user_qr_entity/user_qr_entity.dart';

abstract class IUserQrService {
  Future<void> saveUserQr(UserQrEntity userQr);
  Future<List<UserQrEntity>> getUserQrs();
  Future<void> deleteUserQr(String id);
}
