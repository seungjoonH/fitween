import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/home/ranking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeP extends GetxController {
  static Size screenSize = MediaQuery.of(Get.context!).size;
  static final refreshCont = RefreshController();

  static void toHome() => Get.offAllNamed('/home');

  static Future init() async {
    final homeP = Get.find<HomeP>();
    final loadingP = Get.find<LoadingP>();

    loadingP.loadStart();
    await homeP.loadAll();
    loadingP.loadEnd();
  }

  Future loadAll() async {
    final userRecordP = Get.find<UserRecordP>();
    final userFriendP = Get.find<UserFriendP>();
    final rankingP = Get.find<RankingP>();

    await userRecordP.load();
    userRecordP.clearRecords();
    if (!await userRecordP.fetchData()) await userRecordP.load();
    await userFriendP.load();
    await userFriendP.loadFriends();
    await rankingP.loadAll();

    update();
  }

  int rotationIndex = 0;
  bool allowClick = true;
  static String rotationAsset = 'assets/image/page/home/rotation/';
  static late FlutterGifController gifCont;
  String? _gifAsset;

  String get pngAsset => '$rotationAsset${'rbo'[rotationIndex]}.png';
  String? get gifAsset =>
      _gifAsset == null ? null : '$rotationAsset$_gifAsset.gif';

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