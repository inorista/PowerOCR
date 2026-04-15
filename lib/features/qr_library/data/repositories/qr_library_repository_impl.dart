import 'package:injectable/injectable.dart';
import 'package:powerocr/features/qr_library/data/datasource/qr_library_local_datasource.dart';
import 'package:powerocr/features/qr_library/data/models/user_qr_model.dart';
import 'package:powerocr/features/qr_library/domain/entities/user_qr.dart';
import 'package:powerocr/features/qr_library/domain/repositories/qr_library_repository.dart';

@LazySingleton(as: QrLibraryRepository)
class QrLibraryRepositoryImpl implements QrLibraryRepository {
  final QrLibraryLocalDataSource localDataSource;

  QrLibraryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<UserQr>> getUserQrs() async {
    try {
      return await localDataSource.getUserQrs();
    } catch (e) {
      throw Exception('Failed to get user QRs: $e');
    }
  }

  @override
  Future<void> saveUserQr(UserQr userQr) async {
    try {
      final model = UserQrModel(
        id: userQr.id,
        content: userQr.content,
        imagePath: userQr.imagePath,
        title: userQr.title,
      );
      await localDataSource.saveUserQr(model);
    } catch (e) {
      throw Exception('Failed to save user QR: $e');
    }
  }

  @override
  Future<void> deleteUserQr(String id) async {
    try {
      await localDataSource.deleteUserQr(id);
    } catch (e) {
      throw Exception('Failed to delete user QR: $e');
    }
  }
}
