import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/inspection/inspection.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:get/get.dart';

class SeeMoreP extends GetxController {
  static void toSeeMore([bool initialize = false]) async {
    Get.offAllNamed('/seeMore');
    if (initialize) await init();
  }
  static Future init() async {
    if (await Inspection.load()) return;

    final seeMoreP = Get.find<SeeMoreP>();
    final loadingP = Get.find<LoadingP>();

    loadingP.loadStart();
    await seeMoreP.loadCollections();
    loadingP.loadEnd();
  }

  static void logout() {
    showFDialog(
      title: Lang.tr('auth.logout').capitalize!,
      content: FText(Lang.tr('auth.logout-really'), maxLines: 2),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightPressed: AuthP.fLogout,
    );
  }

  static void deleteAccount() {
    showFDialog(
      title: Lang.tr('auth.accdel'),
      content: FText(Lang.tr('auth.accdel-really'), maxLines: 2),
      type: DialogType.bi,
      rightText: Lang.tr('btn.delete'),
      rightBackgroundColor: FTheme.error,
      leftPressed: Get.back,
      rightPressed: AuthP.fDeleteAccount,
    );
  }

  Future loadCollections() async {
    final userP = Get.find<UserCollectionP>();
    await userP.load();
    update();
  }
}