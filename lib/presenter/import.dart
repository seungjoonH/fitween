import 'package:get/get.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/challenge.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/height.dart';
import 'package:fitween/presenter/model/level.dart';
import 'package:fitween/presenter/model/quest.dart';
import 'package:fitween/presenter/model/weight.dart';

class ImportPresenter extends GetxController {
  static void importData() {
    BadgePresenter.importFile();
    ChallengePresenter.importFile();
    WeightPresenter.importFile();
    HeightPresenter.importFile();
    LevelPresenter.importFile(ActivityType.calorie);
    LevelPresenter.importFile(ActivityType.distance);
    LevelPresenter.importFile(ActivityType.height);
    LevelPresenter.importFile(ActivityType.weight);
    QuestPresenter.importFile();
  }
}