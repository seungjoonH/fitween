import 'package:get/get.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/json/challenge.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/height.dart';
import 'package:fitween/presenter/model/json/level.dart';
import 'package:fitween/presenter/model/json/quest.dart';
import 'package:fitween/presenter/model/weight.dart';

class ImportPresenter extends GetxController {
  static void importData() {
    BadgeJsonP.importFile();
    ChallengeJsonP.importFile();
    WeightPresenter.importFile();
    HeightPresenter.importFile();
    // LevelJsonP.importFile(ActivityType.calorie);
    LevelJsonP.importFile(ActivityType.distance);
    LevelJsonP.importFile(ActivityType.height);
    LevelJsonP.importFile(ActivityType.weight);
    QuestJsonP.importFile();
  }
}
