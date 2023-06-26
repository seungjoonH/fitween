import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:get/get.dart';

class SeeMoreP extends GetxController {
  static void toSeeMore([bool initialize = false]) async {
    Get.offAllNamed('/seeMore');
    if (initialize) await init();
  }
  static Future init() async {
    final seeMoreP = Get.find<SeeMoreP>();
    final loadingP = Get.find<LoadingP>();

    loadingP.loadStart();
    await seeMoreP.loadCollections();
    loadingP.loadEnd();
  }

  Future loadCollections() async {
    final userP = Get.find<UserCollectionP>();
    await userP.load();
    update();
  }
}