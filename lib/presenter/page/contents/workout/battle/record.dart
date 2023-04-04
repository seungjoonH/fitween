import 'package:fitween/model/class/database/battle.dart';
import 'package:fitween/presenter/model/user/battle.dart';
import 'package:get/get.dart';

class BattleRecordP extends GetxController {
  static void toBattleRecord() {
    Get.toNamed('/contents/workout/battle/record');
    init();
  }

  static void init() {
    final battleRecordP = Get.find<BattleRecordP>();
    battleRecordP.loadAll();
  }

  int win = 0;
  int lose = 0;
  int draw = 0;

  List<Battle> battles = [];

  void loadAll() {
    final userP = Get.find<UserBattleP>();
    win = 0; lose = 0; draw = 0;

    battles = userP.loggedUser.finishedBattles.values.toList();
    battles.sort((a, b) => int.parse(b.id!) - int.parse(a.id!));

    for (Battle battle in battles) {
      if (battle.tied) { draw++; continue; }
      if (battle.won(userP.loggedUser.uid!)) { win++; }
      if (battle.defeated(userP.loggedUser.uid!)) { lose++; }
    }
    update();
  }
}