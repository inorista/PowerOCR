import 'package:powerocr/database/hive_entities/user_qr_entity/user_qr_entity.dart';
import 'package:powerocr/features/qr_library/domain/entities/user_qr.dart';

class UserQrModel extends UserQr {
  const UserQrModel({
    required super.id,
    required super.content,
    required super.imagePath,
    super.title,
  });

  factory UserQrModel.fromEntity(UserQrEntity entity) {
    return UserQrModel(
      id: entity.id,
      content: entity.content,
      imagePath: entity.imagePath,
      title: entity.title,
    );
  }

  UserQrEntity toEntity() {
    final entity = UserQrEntity(
      content: content,
      imagePath: imagePath,
      title: title,
    );
    entity.id = id;
    return entity;
  }
}
