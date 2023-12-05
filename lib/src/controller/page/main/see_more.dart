import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SeeMorePageCont extends MainPageCont {
  static SeeMorePageCont get to => Get.find<SeeMorePageCont>();

  String get appBarTitle => LangCont.tr('appbar.see-more');
  String get fPointCardTitle => LangCont.tr('see-more.fpoint.title');
  String get myBadgeCardTitle => LangCont.tr('see-more.badge.title');
  String get inventoryCardTitle => LangCont.tr('see-more.inventory.title');
  String get infoSettingCardTitle => LangCont.tr('see-more.info-setting.title');

  String get mainText => LangCont.tr('word.main').capitalize!;
  String get recentText => LangCont.tr('word.recent').capitalize!;

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

  void fPointCardPressed() => FRoute.toFPoint();
  void badgeCardPressed() => FRoute.toBadge();
  void inventoryCardPressed() => FRoute.toInventory();
  void notificationButtonPressed() => FRoute.toNotification();
  void settingsButtonPressed() => FRoute.toSettings();
}