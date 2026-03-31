import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

class BaseEntity {
  @HiveField(0)
  late String id;

  BaseEntity({String? id}) {
    this.id = id ?? const Uuid().v4();
  }
}
