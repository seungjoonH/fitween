import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageCont extends MainPageCont {
  static HomePageCont get to => Get.find<HomePageCont>();

  static const _arrowAsset = 'assets/image/page/home/';
  String get leftArrowAsset => '${_arrowAsset}left_arrow.svg';
  String get rightArrowAsset => '${_arrowAsset}right_arrow.svg';

  final _activeType = FType.distance.obs;
  FType get activeType => _activeType.value;
  int get activeIndex => activeType.index - 1;

  void setType(FType type) => _activeType(type);
  void onChanged(int index) => setType(FType.activeValues[index]);

  String getMarbleCenterText(FType type) {
    num record = _logged.getOneDayRecord(CalendarCont.to.selectedDay)[type]!;
    return type.withUnit(record, txs: true);
  }

  CalendarCont get calendarCont => CalendarCont.to;
  RankingCont get rankingCont => RankingCont.to;

  @override
  String get loadKey => 'home';

  @override
  Future load() async {
    await calendarCont.init();
    await rankingCont.init();
  }

  @override
  Future afterRoute() async {
    delay(500.ms, gotoSelectedWeek);
  }

  FUser get _logged => AuthCont.logged!;

  String get recordCardTitle => LangCont.tr('home.record');
  String get viewTodayText => LangCont.tr('home.record-card.view-today');
  String get rankingCardTitle => LangCont.tr('home.ranking');
  String get noFriendsText => LangCont.tr('friend.no-friends');

  DateTime get firstDay => _logged.regDate;

  final carouselCont = CarouselController();
  int get carouselCount => _logged.weekCount + 1;

  final _pageIndex = 0.obs;
  int get pageIndex => _pageIndex.value;

  final _isLastPage = false.obs;
  bool get isLastPage => _isLastPage.value;

  void _setIsLastPage() => _isLastPage(pageIndex == carouselCount - 1);

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    _pageIndex(index); _setIsLastPage();
  }

  int get selectedWeekIndex => 1 + calendarCont
      .selectedDay.firstDayOfWeek
      .difference(firstDay).inDays ~/ 7;

  void _animateTo(int index) {
    carouselCont.animateToPage(index, curve: Curves.easeInOut);
    _setIsLastPage();
  }

  void _animateToLast() => _animateTo(carouselCount - 1);

  void gotoSelectedWeek() => _animateTo(selectedWeekIndex);
  void selectToday() {
    calendarCont.selectDay(today);
    _animateToLast();
  }

  void onRecordCardPressed() => FRoute.toCalendar();
  void onRankingCardPressed() => FRoute.toRanking();

}