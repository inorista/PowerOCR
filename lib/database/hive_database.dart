import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase {
  Future<void> setupHiveDatabase() async {
    Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
  }
}

class HiveBoxIds {
  //static const entity = 1;
}
