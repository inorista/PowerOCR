import 'package:powerocr/features/qr_library/domain/entities/user_qr.dart';

abstract class QrLibraryRepository {
  Future<List<UserQr>> getUserQrs();
  Future<void> saveUserQr(UserQr userQr);
  Future<void> deleteUserQr(String id);
}
