import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/widget/function/dialog.dart';
import 'package:get/get.dart';

class LevelDetailPageCont extends PageCont {
  static LevelDetailPageCont get to => Get.find<LevelDetailPageCont>();

  AdventurePageCont get adventureCont => AdventurePageCont.to;

  Level? get level => adventureCont.selectedLevel!;
  Amount get amount => adventureCont.amount;
  LevelLocal get levelLocal => LevelLocal.byType(adventureCont.activeType)!;

  bool get isCurrent => level!.isEqualTo(levelLocal.getCurrentLevel(amount));

  String get centerText {
    FType type = adventureCont.activeType;
    String currentAmountText = level!.getCurrentValue(amount).thouSep;
    String goalText = type.withUnit(level!.goal, scaling: false);
    return '$currentAmountText / $goalText';
  }

  final _compensationBadge = Rx<FBadge?>(null);
  final _compensationBadgeAvailable = false.obs;
  final _badgeCanBeEarned = false.obs;

  FBadge? get compensationBadge => _compensationBadge.value;
  bool get compensationBadgeAvailable => _compensationBadgeAvailable.value;
  bool get badgeCanBeEarned => _badgeCanBeEarned.value;

  Future _setCompensationBadgeState() async {
    FBadge badge = FBadge.fromId(level!.badgeId);
    _compensationBadge(badge);
    _compensationBadgeAvailable(await badge.activate);
    _badgeCanBeEarned(compensationBadge!.canBeEarned);
  }

  @override
  Future load() async => await _setCompensationBadgeState();

  @override
  String get loadKey => 'level-detail';

  void badgePressed() async {
    if (!compensationBadgeAvailable) return;
    await FBadgeCont.to.earnBadge(compensationBadge!.key);
    await load();
  }
}