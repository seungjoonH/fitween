import 'dart:math';
import 'dart:ui';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/health/health.dart';
import 'package:fitween/src/model/class/date_range.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarEvent {
  num goal;
  num amount;

  CalendarEvent(this.goal, this.amount);

  bool get completed => goal <= amount;
  double get percent => amount / goal;
}

class CalendarPageCont extends PageCont {
  static CalendarPageCont get to => Get.find<CalendarPageCont>();

  FUser? _rival;
  FUser get rival => _rival!;

  void setRival(FUser rival) => _rival = rival;

  CalendarCont get calendarCont => CalendarCont.to;
  HomePageCont get homePageCont => HomePageCont.to;

  String get appBarTitle => LangCont.tr('appbar.calendar');

  String get _dialogTr => 'calendar.dialog';
  String get fetchInfoTitle => LangCont.tr('$_dialogTr.fetch.info-title');
  String get fetchInfoText => LangCont.tr('$_dialogTr.fetch.info-text');
  String get fetchReallyTitle => LangCont.tr('$_dialogTr.fetch.really-title');
  String getFetchReallyText([FType? type]) {
    Map<FType, num> amounts = {};

    for (FType type in FType.activeValues.sublist(0, 2)) {
      amounts[type] = calendarCont.getUnreflectedAmount(type, _selectedDay);
    }

    num disAmount = amounts[FType.distance]!;
    num heiAmount = amounts[FType.height]!;
    String disText = '@{${FType.distance.withUnit(disAmount, scaling: false)}}';
    String heiText = '@{${FType.height.withUnit(heiAmount, scaling: false)}}';

    bool dis = type == null && disAmount != 0 || type == FType.distance;
    bool hei = type == null && heiAmount != 0 || type == FType.height;

    if (!dis) disText = '@{}';
    if (!hei) heiText = '@{}';

    List<String> amountTexts = [disText, heiText];

    String text = amountTexts.join('');
    if (dis && hei) text = amountTexts.join(', ');

    return LangCont.tr(
      '$_dialogTr.fetch.really-text',
      namedArgs: {'fpoint': '${getSpendingFPoint(type)}', 'amount': text},
    );
  }

  String get fetchedTitle => LangCont.tr('$_dialogTr.fetch.complete-title');
  String get fetchedText => LangCont.tr('$_dialogTr.fetch.complete-text');

  String get fetchAllTitle => LangCont.tr('$_dialogTr.fetch.all-title');
  String get fetchAllText => LangCont.tr(
    '$_dialogTr.fetch.all-text',
    namedArgs: {'fpoint': getAllSpendingFPoint().thouSep},
  );

  void reflectInformationButtonPressed() {
    showFDialog(
      title: fetchInfoTitle,
      content: FTexts(
        fetchInfoText,
        style: ThemeCont.to.bodyLarge,
        textColor: ThemeCont.to.comment,
        highlightStyle: ThemeCont.to.bodyLarge?.copyWith(
          color: ThemeCont.to.point,
          fontWeight: FontWeight.bold,
        ),
        wordWrap: true,
      ),
      type: DialogType.mono,
    );
  }

  void linearPercentIndicatorWidgetPressed(FType type) {
    bool unreflected = calendarCont.typeHasUnreflectedAmount(type);
    if (!unreflected) return;

    showFDialog(
      title: fetchReallyTitle,
      content: FTexts(
        getFetchReallyText(type),
        style: ThemeCont.to.bodyLarge,
        textColor: ThemeCont.to.comment,
        highlightStyles: [
          ThemeCont.to.bodyLarge!.copyWith(color: ThemeCont.to.point),
          ThemeCont.to.bodyLarge!.copyWith(color: FType.distance.color),
          ThemeCont.to.bodyLarge!.copyWith(color: FType.height.color),
        ],
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightText: fetchButtonText,
      rightBackgroundColor: ThemeCont.to.point,
      rightPressed: () => _fetchData(type),
    );
  }

  String get fetchButtonText => LangCont.tr('button.fetch');

  void fetchButtonPressed() {
    showFDialog(
      title: fetchReallyTitle,
      content: FTexts(
        getFetchReallyText(),
        style: ThemeCont.to.bodyLarge,
        textColor: ThemeCont.to.comment,
        highlightStyles: [
          ThemeCont.to.bodyLarge!.copyWith(color: ThemeCont.to.point),
          ThemeCont.to.bodyLarge!.copyWith(color: FType.distance.color),
          ThemeCont.to.bodyLarge!.copyWith(color: FType.height.color),
        ],
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightText: fetchButtonText,
      rightBackgroundColor: ThemeCont.to.point,
      rightPressed: _fetchAllTypeOfData,
    );
  }

  void refreshButtonPressed() {
    showFDialog(
      title: fetchAllTitle,
      content: FTexts(
        fetchAllText,
        highlightColor: ThemeCont.to.point,
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightText: fetchButtonText,
      rightBackgroundColor: ThemeCont.to.point,
      rightPressed: _fetchAllData,
    );
  }

  DateTime get _selectedDay => calendarCont.selectedDay;

  Future _showFetchedDialog() async {
    await showFDialog(
      title: fetchedTitle,
      content: FText(fetchedText, maxLines: 0),
      type: DialogType.mono,
    );
  }

  void _fetchData(FType type) async {
    bool spent = await FPointCont.to.spend(getSpendingFPoint(type), 'fetch-data-${type.name}');
    if (!spent) return;

    await _showFetchedDialog();
    await HealthDataCont.setOneDayRecordByType(type, _selectedDay);
    await onRefresh();
  }

  void _fetchAllTypeOfData() async {
    bool spent = await FPointCont.to.spend(getSpendingFPoint(), 'fetch-data-two-types');
    if (!spent) return;

    await _showFetchedDialog();
    await HealthDataCont.setOneDayRecordByType(FType.distance, _selectedDay);
    await HealthDataCont.setOneDayRecordByType(FType.height, _selectedDay);

    calendarCont.selectDay(today);
    await delay(10.ms, () => calendarCont.selectDay(_selectedDay));

    await onRefresh();
  }

  void _fetchAllData({bool couponUsed = false}) async {
    if (couponUsed) {
      bool spent = await FPointCont.to.spend(getAllSpendingFPoint(), 'fetch-data-all');
      if (!spent) return;
    }

    await _showFetchedDialog();
    await HealthDataCont.setAllRecordByType(FType.distance);
    await HealthDataCont.setAllRecordByType(FType.height);

    calendarCont.selectDay(today);

    await onRefresh();
  }

  int getSpendingFPoint([FType? type, DateTime? date]) {
    int diff = today.difference(date ?? _selectedDay).inDays;
    bool dis = calendarCont.typeHasUnreflectedAmount(FType.distance, date);
    bool hei = calendarCont.typeHasUnreflectedAmount(FType.height, date);

    if (!dis && !hei || diff < 2) return 0;

    int w = type == null && dis && hei ? 2 : 1;
    return w * min(100 + 50 * (max(diff - 1, 0)), 1000);
  }

  int getAllSpendingFPoint() {
    DateRange range = DateRange(_logged.regDate.ignoreTime, today);
    int fp = 0;
    for (DateTime date in range.dates) {
      fp += getSpendingFPoint(null, date);
    }
    return min(fp, 20000);
  }

  FUser get _logged => AuthCont.logged!;

  @override
  String get loadKey => 'calendar';


  @override
  Future load() async => await calendarCont.init();

}