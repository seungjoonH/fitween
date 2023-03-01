import 'package:fitween/model/enum/activity_type.dart';
import 'package:get/get.dart';

/// class
class AchievementLevelP extends GetxController {
  static void toAchievementLevel(ActivityType type) {
    Get.toNamed('/contents/achievementLevel', arguments: type);
  }
}