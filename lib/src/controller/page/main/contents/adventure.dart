import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AdventurePageCont extends PageCont {
  static AdventurePageCont get to => Get.find<AdventurePageCont>();
  static String get topCloudAsset {
    String dayOrNight = ThemeCont.to.isLightMode ? 'day' : 'night';
    return 'assets/image/page/contents/adventure/top_cloud_$dayOrNight.png';
  }

  final scrollCont = ScrollController();


  final _list = <Level>[].obs;
  final _activeType = FType.distance.obs;

  List<Level> get list => _list;
  FType get activeType => _activeType.value;

  final _ratios = <int>[];
  final _periods = <int>[];
  static const int _defaultPeriod = 1000;
  static const int _maxNumber = 1000;

  Amount get amount {
    return logged.record!.allAmount[activeType]!;
  }

  double get percent => selectedLevel!.getPercent(amount);

  void setType(FType type) {
    _activeType(type);
    LevelLocal levelLocal = LevelLocal.byType(type)!;
    List<Level> list = levelLocal.getAchievedList(amount);
    _list.assignAll(list);
    if (activeType == type) return;
    _setRandomRatios();
    _setRandomPeriods();
  }

  void _setRandomRatios() {
    Random random = Random();
    List<int> randList = List.generate(list.length, (i) {
      int range = (_maxNumber * .5).toInt();
      int start = ((i % 2) * range).toInt();
      return start + random.nextInt(range);
    });
    _ratios.assignAll(randList);
  }

  void _setRandomPeriods() {
    Random random = Random();
    List<int> randList = List.generate(list.length, (i) {
      int range = 200;
      double start = _defaultPeriod - range * .5;
      return (start + random.nextInt(range)).toInt();
    });
    _periods.assignAll(randList);
  }

  void _gotoBottom() {
    scrollCont.jumpTo(scrollCont.position.maxScrollExtent);
  }

  void _scrollUpToTop() {
    scrollCont.animateTo(.0,
      duration: 1.s,
      curve: Curves.easeInOut,
    );
  }

  @override
  Future load() async {
    setType(FType.distance);
    _gotoBottom();
    _setRandomRatios();
    _setRandomPeriods();
    _scrollUpToTop();
    await FriendCont.to.init();
    await syncLevelReceivedFrom();
  }

  int getLeftRatio(int index) => _ratios[index];
  int getRightRatio(int index) => _maxNumber - _ratios[index];
  int getPeriod(int index) => _periods[index];

  final _selectedLevel = Rx<Level?>(null);
  Level? get selectedLevel => _selectedLevel.value;

  void islandWidgetPressed(Level level) {
    if (!level.isAchievedAmount(amount)) return;
    _selectedLevel.value = level;
    FRoute.toLevelDetail();
  }

  final _levelReceived = <String, List<bool>>{}.obs;

  void setLevelReceived(Map<String, List<bool>> data) {
    _levelReceived.assignAll({...data});
  }

  Future syncLevelReceivedFrom() async {
    await AuthCont.load(FUserLoadCont.onlyCollection());
    setLevelReceived(logged.collection!.levelReceived);
  }

  bool levelFinished(Level level) {
    return level.isLessThan(LevelLocal.byType(level.type)!.getCurrentLevel());
  }

  bool hasBadgeToReceive(Level level) {
    bool badgeExists = FBadge.fromId(level.badge.key).activeSync;
    bool hasBadge = logged.collection!.badgeAlreadyEarned(level.badge.key);
    return badgeExists && !hasBadge;
  }

  bool hasItemToReceive(Level level) {
    List<bool> list = _levelReceived[level.key] ?? [];
    int maxLength = level.pointDivided.where((e) => e != 0).length;
    return list.length < maxLength || list.contains(false);
  }

  bool hasToReceived(Level level) {
    return hasBadgeToReceive(level) || hasItemToReceive(level);
  }

  @override
  String get loadKey => 'adventure';
}