import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/battle.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/json/battle.dart';
import 'package:fitween/presenter/model/user/battle.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/contents/workout/solo/result.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:get/get.dart';

class BattleResultP extends GetxController {
  static void toBattleResult(String id, {int? count, bool offAll = true}) async {
    String route = '/contents/workout/battle/result';
    if (offAll) { Get.offAllNamed(route); }
    else { Get.toNamed(route); }
    await init(id: id, count: count, offAll: offAll);
  }

  static Future init({String? id, int? count, bool offAll = true}) async {
    final workoutSoloResultP = Get.find<WorkoutSoloResultP>();
    final battleResultP = Get.find<BattleResultP>();
    final loadingP = Get.find<LoadingP>();

    loadingP.loadStart();
    if (count != null) await workoutSoloResultP.loadAll(count);
    await battleResultP.loadAll(id, offAll);
    loadingP.loadEnd();
  }

  Battle? battle;
  bool offAll = true;

  Future loadAll([String? id, bool offAll = true]) async {
    final userP = Get.find<UserBattleP>();
    if (id == null) return;
    this.offAll = offAll;
    battle = await BattleJsonP.load(id);
    await userP.loadMyBattles();
    update();
  }
}