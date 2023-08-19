import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/user/auth.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageCont extends GetxController {
  static HomePageCont get to => Get.find<HomePageCont>();

  static const _arrowAsset = 'assets/image/page/home/';
  String get leftArrowAsset => '${_arrowAsset}left_arrow.svg';
  String get rightArrowAsset => '${_arrowAsset}right_arrow.svg';

  final _activeType = FType.distance.obs;
  FType get activeType => _activeType.value;

  void onChanged(int index) => _activeType(FType.activeValues[index]);

  final _refreshCont = RefreshController();
  RefreshController get refreshCont => _refreshCont;

  CalendarCont get calendarCont => Get.find<CalendarCont>();
  RankingCont get rankingCont => Get.find<RankingCont>();

  Future init() async {
    if (LoadingCont.start('ranking', 5)) {
      await calendarCont.init();
      await rankingCont.init();
    }
    LoadingCont.end();
  }

  FUser get _logged => AuthCont.logged!;

  String get recordCardTitle => LangCont.tr('home.record');
  String get rankingCardTitle => LangCont.tr('home.ranking');

  void onRecordCardPressed() {}
  void onRankingCardPressed() {}

}