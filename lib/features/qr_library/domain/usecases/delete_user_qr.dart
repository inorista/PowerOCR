import 'package:injectable/injectable.dart';
import 'package:powerocr/features/qr_library/domain/repositories/qr_library_repository.dart';

@lazySingleton
class DeleteUserQr {
  final QrLibraryRepository repository;

  DeleteUserQr(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteUserQr(id);
  }
}
