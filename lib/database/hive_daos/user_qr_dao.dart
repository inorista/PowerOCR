import 'package:injectable/injectable.dart';
import 'package:powerocr/database/hive_daos/base_dao.dart';
import 'package:powerocr/database/hive_database.dart';
import 'package:powerocr/database/hive_entities/user_qr_entity/user_qr_entity.dart';

@lazySingleton
class UserQrDao extends BaseDao<UserQrEntity> {
  UserQrDao() : super(HiveBoxIds.userQrEntity);
}
