import 'package:get/get.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/level.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user.dart';

/// class
class RecordMain extends GetxController {
  /// static methods
  // 기록 메인 페이지로 이동
  static void toRecordMain() {
    final recordMain = Get.find<RecordMain>();
    Get.toNamed('/record/main');
    recordMain.loadTiers();
  }

  /// attributes
  Map<ActivityType, Map<String, dynamic>> tiers = {};

  /// methods
  //
  void loadTiers() {
    final userP = Get.find<UserP>();

    for (ActivityType type in ActivityType.activeValues) {
      double amount = userP.loggedUser.getAmounts(type);
      Record record = Record.init(type, amount, ExerciseUnit.kilometer);

      tiers[type] = LevelPresenter.getTier(type, record);
    }
    update();
  }
}