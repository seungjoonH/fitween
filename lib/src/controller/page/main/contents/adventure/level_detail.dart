import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class LevelDetailPageCont extends PageCont {
  static LevelDetailPageCont get to => Get.find<LevelDetailPageCont>();

  AdventurePageCont get adventureCont => AdventurePageCont.to;

  Level? get level => adventureCont.selectedLevel!;
  Amount get amount => adventureCont.amount;
  LevelLocal get levelLocal => LevelLocal.byType(adventureCont.activeType)!;

  String get centerText {
    FType type = adventureCont.activeType;
    String currentAmountText = level!.getCurrentValue(amount).thouSep;
    String goalText = type.withUnit(level!.goal, scaling: false);
    return '$currentAmountText / $goalText';
  }

  @override
  Future load() async {}

  @override
  String get loadKey => 'level-detail';
}