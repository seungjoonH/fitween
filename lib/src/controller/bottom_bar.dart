import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class BottomBarCont extends GetxController {
  static BottomBarCont get to => Get.find<BottomBarCont>();

  final _pageIndex = (-1).obs;
  int get pageIndex => _pageIndex.value;

  void navigate(int index) async {
    if (LoadingCont.to.loading) return;
    if (pageIndex == index) {
      await [
        HomePageCont.to.init,
        FriendPageCont.to.init,
        ContentsPageCont.to.init,
        SeeMorePageCont.to.init,
      ][index]();
      return;
    }
    _pageIndex(index);
    [
      FRoute.toHome,
      FRoute.toFriend,
      FRoute.toContents,
      FRoute.toSeeMore,
    ][index]();
  }
}