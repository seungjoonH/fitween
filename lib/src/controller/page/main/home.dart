import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:fitween/src/view/widget/widget/gift.dart';
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
  void onChanged(int index) => setType(FType.activeValues[index]);

  String getMarbleCenterText(FType type) {
    num record = _logged.getOneDayRecord(CalendarCont.to.selectedDay)[type]!;
    return type.withUnit(record, txs: true);
  }

  final _hasGiftReceived = false.obs;
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
            onPressed: () {
              Get.back();
              inventoryCont.showAwardedItemInformationDialog(_giftData);
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
    await FBadgeCont.to.init();
  }

  @override
  Future afterRoute() async {
    _setGiftReceivedState();
    delay(2.s, () {
      if (BottomBarCont.to.pageIndex != 0) return;
      gotoSelectedWeek();
    });
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
  void selectToday() {
    calendarCont.selectDay(today);
    _animateToLast();
  }

  void onRecordCardPressed() => FRoute.toCalendar();
  void onRankingCardPressed() => FRoute.toRanking();

}