import 'dart:async';

import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:get/get.dart';

class FPointCont extends GetxController {
  static FPointCont get to => Get.find<FPointCont>();

  final _point = 0.obs;
  int get fPoint => _point.value;

  List<PointHistoryData> get pointHistory {
    int compare(PointHistoryData a, PointHistoryData b) {
      return b.date.compareTo(a.date);
    }
    return _logged.pointHistory..sort(compare);
  }

  FUser get _logged => AuthCont.logged!;

  void _syncFP() => _point(_logged.fPoint);

  Future load() async {
    await AuthCont.load(FUserLoadCont.onlyPoint());
    _syncFP();
  }

  void earn(int fp, String content) async {
    if (fp == 0) return;
    _logged.point!.earn(fp, content);
    _syncFP();
    await FUserPointDAO().saveOne(_logged.point!);
  }

  Future<bool> spend(int fp, String content) async {
    if (fp == 0) return true;
    if (_logged.point!.fPoint.abs() < fp) {
      _showInsufficientPointDialog();
      return false;
    }

    _logged.point!.spend(fp, content);
    _syncFP();
    await FUserPointDAO().saveOne(_logged.point!);
    return true;
  }

  String get fPointInsufficientTitle => LangCont.tr('fpoint.dialog.insufficient-title');
  String get fPointInsufficientText => LangCont.tr('fpoint.dialog.insufficient-text');

  void _showInsufficientPointDialog() {
    showFDialog(
      title: fPointInsufficientTitle,
      content: FText(fPointInsufficientText, maxLines: 0),
      type: DialogType.mono,
    );
  }
}