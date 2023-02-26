import 'package:fitween/presenter/model/user/collection.dart';
import 'package:get/get.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/enum/page_mode.dart';
import 'package:fitween/presenter/global.dart';

/// class
class CollectionMainP extends GetxController {
  /// static methods
  // 컬렉션 메인 페이지로 이동
  static Future<bool> toCollectionMain() async {
    final collectionMain = Get.find<CollectionMainP>();
    collectionMain.init();
    return await Get.toNamed('/collection/main');
  }

  /// attributes
  PageMode mode = PageMode.view;
  String? selectedBadgeId;

  /// methods
  // 초기화
  void init() {
    final userP = Get.find<UserCollectionP>();
    selectedBadgeId = userP.loggedUser.badgeId;
    mode = PageMode.view;
    update();
  }

  // 편집, 읽기전용 모드 변환
  // void toggleMode() {
  //   mode = PageMode.values[1 - mode.index];
  //
  //   switch (mode) {
  //     case PageMode.view:
  //       break;
  //     default: break;
  //   }
  //   update();
  // }

  // 대표 컬렉션 설정
  void setMainBadge(Collection collection) {
    final userP = Get.find<UserCollectionP>();

    if (selectedBadgeId == collection.badgeId) return;
    selectedBadgeId = collection.badgeId;

    userP.setMainBadge(selectedBadgeId!);
    update();
  }

  // 컬렉션 클릭 시
  void collectionPressed(Collection collection) {
    switch (mode) {
      case PageMode.view:
        GlobalP.showCollectionDialog(collection);
        break;
      case PageMode.edit:
        collectionSelected(collection);
        break;
    }
    update();
  }

  // 편집모드에서 컬렉션 선택 시
  void collectionSelected(Collection collection) {
    selectedBadgeId = selectedBadgeId == collection.badgeId
        ? null : selectedBadgeId = collection.badgeId;
    update();
  }
}