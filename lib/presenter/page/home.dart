import 'package:carousel_slider/carousel_controller.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
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
  static Size screenSize = MediaQuery.of(Get.context!).size;
  static final refreshCont = RefreshController();

  static void toHome() => Get.offAllNamed('/home');

  int rotationIndex = 0;
  bool allowClick = true;
  static String rotationAsset = 'assets/image/page/home/rotation/';
  static late FlutterGifController gifCont;
  String? _gifAsset;

  String get pngAsset => '$rotationAsset${'rbo'[rotationIndex]}.png';
  String? get gifAsset =>
      _gifAsset == null ? null : '$rotationAsset$_gifAsset.gif';

  static Future init() async {
    final userRecordP = Get.find<UserRecordP>();
    final userFriendP = Get.find<UserFriendP>();
    final loadingP = Get.find<LoadingP>();

    loadingP.loadStart();

    await userRecordP.load();
    userRecordP.clearRecords();
    if (!await userRecordP.fetchData()) await userRecordP.load();
    await userFriendP.load();
    await userFriendP.loadFriends();

    loadingP.loadEnd();
    userFriendP.update();
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
        Get.back();
        EditGoalP.toEditGoal();
      },
    );
  }

  bool isToday = true;

  Future init() async {
    final userRecordP = Get.find<UserRecordP>();
    final userFriendP = Get.find<UserFriendP>();
    final userP = Get.find<UserRecordP>();
    // final loadingP = Get.find<LoadingP>();

    isToday = true;
    // loadingP.loadStart();

    graphStates = {
      ActivityType.calorie: false,
      ActivityType.distance: false,
      ActivityType.height: false,
      ActivityType.weight: false,
    };

    await userRecordP.load();
    userRecordP.clearRecords();
    if (!await userRecordP.fetchData()) await userRecordP.load();
    userRecordP.updateCalorie();
    await userFriendP.loadFriends();
    await BadgePresenter.synchronizeBadges();

    // loadingP.loadEnd();

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
    isToday = index == 1;
    update();
  }

  Map<ActivityType, bool> graphStates = {
    ActivityType.calorie: false,
    ActivityType.distance: false,
    ActivityType.height: false,
    ActivityType.weight: false,
  };

  void showLaterGraph(ActivityType type) {
    graphStates[type] = true;
    update();
  }
}
