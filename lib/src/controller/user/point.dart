import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
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

  Future load() async {
    await AuthCont.load(FUserLoadCont.onlyPoint());
    _point(_logged.points);
  }

  void earn(int fp, String content) async {
    _logged.point!.earn(fp, content);
    await FUserPointDAO().saveOne(_logged.point!);
  }

  void spend(int fp, String content) async {
    _logged.point!.spend(fp, content);
    await FUserPointDAO().saveOne(_logged.point!);
  }
}