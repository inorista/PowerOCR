import 'package:injectable/injectable.dart';
import 'package:powerocr/features/qr_library/domain/entities/user_qr.dart';
import 'package:powerocr/features/qr_library/domain/repositories/qr_library_repository.dart';

@lazySingleton
class SaveUserQr {
  final QrLibraryRepository repository;

  SaveUserQr(this.repository);

  Future<void> call(UserQr userQr) async {
    return await repository.saveUserQr(userQr);
  }
}
