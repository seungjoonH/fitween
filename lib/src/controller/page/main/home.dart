import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePageCont extends MainPageCont {
  static HomePageCont get to => Get.find<HomePageCont>();

  static const _homeAsset = 'assets/image/page/home/';
  String get leftArrowAsset => '${_homeAsset}left_arrow.svg';
  String get rightArrowAsset => '${_homeAsset}right_arrow.svg';

  final _activeType = FType.distance.obs;
  FType get activeType => _activeType.value;
  int get activeIndex => activeType.index - 1;

  void setType(FType type) => _activeType(type);
  void onChanged(int index) {
    setType(FType.activeValues[index]);
    syncMarbleCenterRecords();
  }

  final _record = Rx<num>(0);
  HeightAmount get heightAmount => HeightAmount()..floor = _record.value;
  WeightAmount get weightAmount => WeightAmount()..cnt = _record.value;
  String get marbleCenterText => activeType.withUnit(_record.value, txs: true);

  static const int _maxLog = 10;
  final _androidLog = <DateTime>[].obs;
  final _weightLog = <DateTime>[].obs;

  void syncMarbleCenterRecords([DateTime? date]) {
    date ??= calendarCont.selectedDay;
    var cont = RecordCont.logged()..syncFromUser();
    _record(cont.getOneDayValue(activeType, date));
    _androidLog(_logged.record!.androidLog);
    _weightLog(_logged.record!.weightLog);
  }

  void countUpButtonPressed(FType type) async {
    switch (type) {
      case FType.height: countHeightUpButtonPressed(); break;
      case FType.weight: countWeightUpButtonPressed(); break;
      default: break;
    }
  }

  void countDownButtonPressed(FType type) async {
    switch (type) {
      case FType.height: countHeightDownButtonPressed(); break;
      case FType.weight: countWeightDownButtonPressed(); break;
      default: break;
    }
  }

  void countHeightUpButtonPressed() async {
    bool cond = false;
    if (_androidLog.length < _maxLog) { cond = true; }
    else if (_androidLog.first.add(3.h).isBefore(now)) {
      _androidLog.removeAt(0); cond = true;
    }

    if (!cond) return;

    _androidLog.add(now);
    _record(_record.value + 1);
    await _saveHeightRecord();
  }

  void countHeightDownButtonPressed() async {
    if (activeType != FType.height) return;
    if (_androidLog.isEmpty) return;
    _androidLog.removeLast();
    _record(_record.value - 1);
    await _saveHeightRecord();
  }

  void countWeightUpButtonPressed() async {
    bool cond = false;
    if (_weightLog.length < _maxLog) { cond = true; }
    else if (_weightLog.first.add(3.h).isBefore(now)) {
      _weightLog.removeAt(0); cond = true;
    }

    if (!cond) return;

    _weightLog.add(now);
    _record(_record.value + 10);
    await _saveWeightRecord();
  }

  void countWeightDownButtonPressed() async {
    if (activeType != FType.weight) return;
    if (_weightLog.isEmpty) return;
    if (_record.value < 10) return;
    _weightLog.removeLast();
    _record(_record.value - 10);
    await _saveWeightRecord();
  }

  Future _saveHeightRecord() async {
    var cont = RecordCont.logged()..syncFromUser();
    cont.setTodayAmount(FType.height, heightAmount);
    _logged.record!.syncAndroidLogFrom(_androidLog);
    await FUserRecordDAO().saveOne(_logged.record!);
  }

  Future _saveWeightRecord() async {
    var cont = RecordCont.logged()..syncFromUser();
    cont.setTodayAmount(FType.weight, weightAmount);
    _logged.record!.syncWeightLogFrom(_weightLog);
    await FUserRecordDAO().saveOne(_logged.record!);
  }

  String get _infoDialogTr => 'home.dialog.info';
  String get androidTitle => LangCont.tr('$_infoDialogTr.android-title');
  String get androidText => LangCont.tr('$_infoDialogTr.android-text');
  String get weightTitle => LangCont.tr('$_infoDialogTr.weight-title');
  String get weightText => LangCont.tr('$_infoDialogTr.weight-text');

  void infoButtonPressed(FType type) {
    switch (type) {
      case FType.height: heightInfoButtonPressed(); break;
      case FType.weight: weightInfoButtonPressed(); break;
      default: break;
    }
  }

  void heightInfoButtonPressed() {
    showFDialog(
      title: androidTitle,
      content: FTexts(
        androidText,
        style: ThemeCont.to.bodyLarge,
        highlightStyle: ThemeCont.to.bodyMedium
            ?.copyWith(color: ThemeCont.to.comment),
        wordWrap: true,
      ),
      type: DialogType.mono,
    );
  }

  void weightInfoButtonPressed() {
    showFDialog(
      title: weightTitle,
      content: FTexts(
        weightText,
        style: ThemeCont.to.bodyLarge,
        highlightStyle: ThemeCont.to.bodyMedium
            ?.copyWith(color: ThemeCont.to.comment),
        wordWrap: true,
      ),
      type: DialogType.mono,
    );
  }

  final _hasGiftReceived = true.obs;
  bool get hasGiftReceived => _hasGiftReceived.value;

  void receiveGift() {
    _hasGiftReceived(true);
    _logged.collection!.receiveGift();
  }

  String get _couponAsset => '${_homeAsset}for_$_userClassification.svg';
  String get giftCardText => LangCont.tr('home.gift.text');
  String get _giftDialogTr => 'home.dialog.gift';

  bool get _isNewcomer => _logged.info!.isNewcomer;
  String get _userClassification => _isNewcomer ? 'newcomer' : 'existing';

  String get giftDialogTitle {
    return LangCont.tr('$_giftDialogTr.$_userClassification-title');
  }
  String get giftDialogText {
    return LangCont.tr('$_giftDialogTr.$_userClassification-text');
  }

  Map<String, int> get _giftData {
    return _isNewcomer
        ? <String, int>{'4000006': 1}
        : <String, int>{'4000100': 1, '4000005': 4};
  }

  void giftCardPressed() {
    showFDialog(
      title: giftDialogTitle,
      content: Column(
        children: [
          FText(
            giftDialogText,
            style: ThemeCont.to.bodyMedium,
            maxLines: 0,
            align: TextAlign.center,
          ),
          SizedBox(height: 20.0.h),
          GiftWidget(
            size: 150.0.r,
            onPressed: () async {
              Get.back();
              await inventoryCont.awardItems(_giftData);
            },
            afterWidget: GlowEffectWidget(
              child: SvgPicture.asset(_couponAsset),
            ),
          ),
        ],
      ),
    );
  }

  CalendarCont get calendarCont => CalendarCont.to;
  RankingCont get rankingCont => RankingCont.to;
  InventoryCont get inventoryCont => InventoryCont.to;

  void _setGiftReceivedState() {
    _hasGiftReceived(_logged.collection!.hasGiftReceived);
  }

  @override
  String get loadKey => 'home';

  @override
  Future load() async {
    await calendarCont.init();
    await rankingCont.init();
    syncMarbleCenterRecords();
  }

  @override
  Future afterRoute() async {
    _earnBadges();
    _setGiftReceivedState();
    delay(2.s, () {
      if (BottomBarCont.to.pageIndex != 0) return;
      gotoSelectedWeek();
    });
  }

  Future _earnBadges() async {
    await FBadgeCont.to.init();
    await FBadgeCont.to.earnBadge('1000000');
    await FBadgeCont.to.earnBadge('1000001');
    await FBadgeCont.to.earnBadge('1000002');
    await FBadgeCont.to.earnBadge('1000003');
    await FBadgeCont.to.earnBadge('1000004');

    await FBadgeCont.to.earnBadge('1060000');
  }

  FUser get _logged => AuthCont.logged!;

  String get recordCardTitle => LangCont.tr('home.record');
  String get viewTodayText => LangCont.tr('home.record-card.view-today');
  String get rankingCardTitle => LangCont.tr('home.ranking');
  String get noFriendsText => LangCont.tr('friend.no-friends');

  DateTime get firstDay => _logged.regDate;

  CarouselController carouselCont = CarouselController();
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

  void selectDay(DateTime date) {
    calendarCont.selectDay(date);
    syncMarbleCenterRecords(date);
  }
  void selectToday() {
    selectDay(today);
    _animateToLast();
  }

  void onRecordCardPressed() => FRoute.toCalendar();
  void onRankingCardPressed() => FRoute.toRanking();

}
