import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';

class SeeMorePageCont extends MainPageCont {
  static SeeMorePageCont get to => Get.find<SeeMorePageCont>();

  String get appBarTitle => LangCont.tr('appbar.see-more');
  String get myBadgeCardTitle => LangCont.tr('see-more.badge.title');
  String get goalSettingCardTitle => LangCont.tr('see-more.goal-setting.title');
  String get infoSettingCardTitle => LangCont.tr('see-more.info-setting.title');

  @override
  String get loadKey => 'see-more';

  @override
  Future load() async {}

  FUser get _logged => AuthCont.logged!;

  String getGoalTextOf(FType type) {
    num goal = _logged.goal.byType(type);
    return type.withUnit(goal, scaling: false, txs: true);
  }
}