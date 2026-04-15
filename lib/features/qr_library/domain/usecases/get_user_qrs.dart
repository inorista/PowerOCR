import 'package:injectable/injectable.dart';
import 'package:powerocr/features/qr_library/domain/entities/user_qr.dart';
import 'package:powerocr/features/qr_library/domain/repositories/qr_library_repository.dart';

@lazySingleton
class GetUserQrs {
  final QrLibraryRepository repository;

  GetUserQrs(this.repository);

  Future<List<UserQr>> call() async {
    return await repository.getUserQrs();
  }
}
