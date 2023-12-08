import 'dart:math';

import 'package:fitween/global/date.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class WeightCompletePageCont extends PageCont {
  static WeightCompletePageCont get to => Get.find<WeightCompletePageCont>();

  final _count = 0.obs;
  int get count => _count.value;

  String get appBarTitle => LangCont.tr('appbar.weight-complete');

  String get myRecordText => LangCont.tr('weight-complete.my-record');
  String get increasedText => LangCont.tr('weight-complete.record-increased');
  String get completeButtonText => LangCont.tr('button.complete');

  num get goalAmount => logged.goal.weight;
  num get beforeAmount => logged.getOneDayRecord(today)[FType.weight]!;
  num get afterAmount => beforeAmount + count;

  double get beforePercent => max(min(beforeAmount / goalAmount, .95), .0);
  double get afterPercent => max(min(afterAmount / goalAmount, 1.0), .0);

  int get originLeftFlex => (beforePercent * 50.0 - 5).round();
  int get originRightFlex => (95 - beforePercent * 50.0).round();

  double get _avg => (beforePercent + afterPercent) * 50.0;
  int get addedLeftFlex => (_avg - 5).round();
  int get addedRightFlex => (95 - _avg).round();

  void completeButtonPressed() {
    logged.record!.addTodayRecord(FType.weight, WeightAmount()..cnt = count);
    HomePageCont.to.setType(FType.weight);
    BottomBarCont.to.navigate(0);
  }

  @override
  Future load() async {
    _count(0);
    _count(Get.arguments as int);
  }

  @override
  String get loadKey => 'weight-complete';

}