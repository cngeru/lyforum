import 'package:hive_flutter/hive_flutter.dart';
import '../common.dart';

class HiveService {
  static Box<PostModel> getDrafts() => Hive.box<PostModel>("drafts");
}
