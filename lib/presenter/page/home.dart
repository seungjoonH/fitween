import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/page/edit_goal.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeP extends GetxController {
  static void toHome() async {
    final homeP = Get.find<HomeP>();
    Get.offAllNamed('/home');
    await homeP.init();
  }

  static Size screenSize = MediaQuery.of(Get.context!).size;

  int rotationIndex = 0;
  bool allowClick = true;
  static String rotationAsset = 'assets/image/page/home/rotation/';
  static late FlutterGifController gifCont;
  String? _gifAsset;

  String get pngAsset => '$rotationAsset${'rbo'[rotationIndex]}.png';
  String? get gifAsset => _gifAsset == null ? null : '$rotationAsset$_gifAsset.gif';

  Future init() async {
    final userP = Get.find<UserP>();
    final loadingP = Get.find<LoadingPresenter>();

    loadingP.loadStart();

    await userP.load();
    userP.clearRecords();
    if (!await userP.fetchData()) await userP.load();

    loadingP.loadEnd();

    update();
  }

  void leftButtonPressed() async {
    if (!allowClick) return;
    allowClick = false;

    _gifAsset = ['rto', 'btr', 'otb'][rotationIndex];
    gifCont.reset();
    gifCont.animateTo(48, duration: const Duration(milliseconds: 1500));
    update();
    await Future.delayed(const Duration(milliseconds: 1500), () {
      _gifAsset = null;
      rotationIndex = (rotationIndex - 1) % 3;
      allowClick = true;
      update();
    });
  }

  void rightButtonPressed() async {
    if (!allowClick) return;
    allowClick = false;

    _gifAsset = ['rtb', 'bto', 'otr'][rotationIndex];
    gifCont.reset();
    gifCont.animateTo(48, duration: const Duration(milliseconds: 1500));
    update();
    await Future.delayed(const Duration(milliseconds: 1500), () {
      _gifAsset = null;
      rotationIndex = (rotationIndex + 1) % 3;
      allowClick = true;
      update();
    });
  }

}

class HomePresenter extends GetxController {
  static final refreshCont = RefreshController();
  static final carouselCont = CarouselController();

  static Future toHome() async {
    final homeP = Get.find<HomePresenter>();
    Get.offAllNamed('/home');
    await homeP.init();
  }

  static void showRouteEditGoalCheckDialog() {
    showPDialog(
      title: '목표 수정',
      content: FText('목표 수정 페이지로 이동하시겠습니까?'),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightPressed: () {
        Get.back(); EditGoal.toEditGoal();
      },
    );
  }

  bool isToday = true;

  Future init() async {
    final userP = Get.find<UserP>();
    final loadingP = Get.find<LoadingPresenter>();

    isToday = true;
    loadingP.loadStart();

    graphStates = {
      ActivityType.calorie: false,
      ActivityType.distance: false,
      ActivityType.height: false,
      ActivityType.weight: false,
    };

    await userP.load();
    userP.clearRecords();
    if (!await userP.fetchData()) await userP.load();
    userP.updateCalorie();
    await BadgePresenter.synchronizeBadges();

    loadingP.loadEnd();

    update();
  }

  void toggleActivityCard() {
    isToday ? slideLeftActivityCard() : slideRightActivityCard();
  }

  void slideLeftActivityCard() {
    isToday = false;
    carouselCont.animateToPage(0, curve: Curves.easeInOut);
    update();
  }

  void slideRightActivityCard() {
    isToday = true;
    carouselCont.animateToPage(1, curve: Curves.easeInOut);
    update();
  }

  void pageChanged(int index) {
    isToday = index == 1; update();
  }

  Map<ActivityType, bool> graphStates = {
    ActivityType.calorie: false,
    ActivityType.distance: false,
    ActivityType.height: false,
    ActivityType.weight: false,
  };

  void showLaterGraph(ActivityType type) {
    graphStates[type] = true; update();
  }

}