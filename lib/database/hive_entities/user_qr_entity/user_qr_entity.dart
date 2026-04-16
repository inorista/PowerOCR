import 'package:hive_ce/hive.dart';
import 'package:powerocr/database/base_entity.dart';
import 'package:powerocr/database/hive_database.dart';

part 'user_qr_entity.g.dart';

@HiveType(typeId: HiveBoxNums.userQrEntity)
class UserQrEntity extends BaseEntity {
  @HiveField(1)
  String content;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  String? title;

  UserQrEntity({required this.content, required this.imagePath, this.title});
}
