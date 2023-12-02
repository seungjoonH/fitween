import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class FBadgeCont extends GetxController {
  static FBadgeCont get to => Get.find<FBadgeCont>();

  final _data = <String, List<DateTime>>{};

  List<FBadge> get badges => [
    for (String id in _data.keys) FBadge.fromId(id),
  ];

  Future init() async => await _syncFrom();

  Future _syncFrom() async {
    await AuthCont.load(FUserLoadCont.onlyCollection());
    _data.assignAll({..._logged.collection!.dates});
  }

  Future _syncTo() async {
    _logged.collection!.syncBadgesFrom(_data);
    await FUserCollectionDAO().saveOne(_logged.collection!);
  }

  bool hasBadge(String id) => _data.keys.contains(id);

  Future earnBadge(String id) async {
    FBadge badge = FBadge.fromId(id);
    if (!badge.canBeEarned) return;
    List<DateTime>? dates;
    if (hasBadge(id)) dates = _data[id]!..add(now);
    dates ??= [now];
    _data[id] = dates;
    badge.earn();
    await _syncTo();
  }

  FUser get _logged => AuthCont.logged!;
}