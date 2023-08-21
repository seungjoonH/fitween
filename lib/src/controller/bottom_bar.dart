import 'package:get/get.dart';

class BottomBarCont extends GetxController {
  static BottomBarCont get to => Get.find<BottomBarCont>();

  final _pageIndex = 0.obs;
  int get pageIndex => _pageIndex.value;

  void navigate(int index) => _pageIndex(index);
}