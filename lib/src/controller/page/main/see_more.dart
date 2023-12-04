import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SeeMorePageCont extends MainPageCont {
  static SeeMorePageCont get to => Get.find<SeeMorePageCont>();

  String get appBarTitle => LangCont.tr('appbar.see-more');
  String get fPointCardTitle => LangCont.tr('see-more.fpoint.title');
  String get myBadgeCardTitle => LangCont.tr('see-more.badge.title');
  String get inventoryCardTitle => LangCont.tr('see-more.inventory.title');
  String get goalSettingCardTitle => LangCont.tr('see-more.goal-setting.title');
  String get infoSettingCardTitle => LangCont.tr('see-more.info-setting.title');

  String get mainText => LangCont.tr('word.main');
  String get recentText => LangCont.tr('word.recent');

  final refreshCont = RefreshController();

  @override
  String get loadKey => 'see-more';

  @override
  Future load() async {
    await NotificationCont.to.init();
    await FPointCont.to.init();
    await FBadgeCont.to.init();
    await InventoryCont.to.init();
  }

  FUser get _logged => AuthCont.logged!;

  String getGoalTextOf(FType type) {
    num goal = _logged.goal.byType(type);
    return type.withUnit(goal, txs: true);
  }

  void fPointCardPressed() => FRoute.toFPoint();
  void badgeCardPressed() => FRoute.toBadge();
  void inventoryCardPressed() => FRoute.toInventory();
  void goalSettingCardPressed() => FRoute.toGoalSetting();
  void notificationButtonPressed() => FRoute.toNotification();
  void settingsButtonPressed() => FRoute.toSettings();
}