import 'package:carousel_slider/carousel_controller.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';

class HomePageCont extends MainPageCont {
  static HomePageCont get to => Get.find<HomePageCont>();

  static const _arrowAsset = 'assets/image/page/home/';
  String get leftArrowAsset => '${_arrowAsset}left_arrow.svg';
  String get rightArrowAsset => '${_arrowAsset}right_arrow.svg';

  final _activeType = FType.distance.obs;
  FType get activeType => _activeType.value;
  int get activeIndex => activeType.index - 1;

  void onChanged(int index) => _activeType(FType.activeValues[index]);

  String getMarbleCenterText(FType type) {
    num record = _logged.getOneDayRecord(CalendarCont.to.selectedDay)[type]!;
    return type.withUnit(record, txs: true);
  }

  CalendarCont get calendarCont => CalendarCont.to;
  RankingCont get rankingCont => RankingCont.to;

  @override
  Future init() async {
    if (LoadingCont.start('home', 20)) {
      await calendarCont.init();
      await rankingCont.init();
    }
    LoadingCont.end();
    delay(500.ms, gotoSelectedWeek);
  }

  FUser get _logged => AuthCont.logged!;

  String get recordCardTitle => LangCont.tr('home.record');
  String get viewTodayText => LangCont.tr('home.record-card.view-today');
  String get rankingCardTitle => LangCont.tr('home.ranking');

  DateTime get firstDay => _logged.regDate;

  final carouselCont = CarouselController();
  int get carouselCount => _logged.weekCount + 1;

  int get selectedWeekIndex => 1 + calendarCont
      .selectedDay.firstDayOfWeek
      .difference(firstDay).inDays ~/ 7;

  void gotoSelectedWeek() => carouselCont.animateToPage(selectedWeekIndex);
  void selectToday() {
    calendarCont.selectDay(today, today);
    carouselCont.animateToPage(carouselCount - 1);
  }

  void onRecordCardPressed() => FRoute.toCalendar();
  void onRankingCardPressed() {}

}