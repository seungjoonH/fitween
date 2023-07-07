import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
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

  static void logout() {
    showFDialog(
      title: '로그아웃',
      content: FText('정말 로그아웃 하시겠습니까?', maxLines: 2),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightPressed: AuthP.fLogout,
    );
  }

  static void deleteAccount() {
    showFDialog(
      title: '계정삭제',
      content: FText('정말 계정을 삭제하시겠습니까?', maxLines: 2),
      type: DialogType.bi,
      rightText: '삭제하기',
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