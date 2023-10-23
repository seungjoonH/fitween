import 'dart:math';
import 'dart:ui';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/health/health.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/widget/widget.dart';
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

  void reflectInformationButtonPressed() {
    showFDialog(
      title: fetchInfoTitle,
      content: FTexts(
        fetchInfoText,
        style: FTheme.bodyLarge,
        textColor: FTheme.comment,
        highlightStyle: FTheme.bodyLarge?.copyWith(
          color: FTheme.point,
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
        style: FTheme.bodyLarge,
        textColor: FTheme.comment,
        highlightStyles: [
          FTheme.bodyLarge!.copyWith(color: FTheme.point),
          FTheme.bodyLarge!.copyWith(color: FType.distance.color),
          FTheme.bodyLarge!.copyWith(color: FType.height.color),
        ],
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightPressed: () => _fetchData(type),
    );
  }

  String get fetchButtonText => LangCont.tr('button.fetch');

  void fetchButtonPressed() {
    showFDialog(
      title: fetchReallyTitle,
      content: FTexts(
        getFetchReallyText(),
        style: FTheme.bodyLarge,
        textColor: FTheme.comment,
        highlightStyles: [
          FTheme.bodyLarge!.copyWith(color: FTheme.point),
          FTheme.bodyLarge!.copyWith(color: FType.distance.color),
          FTheme.bodyLarge!.copyWith(color: FType.height.color),
        ],
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightPressed: _fetchAllTypeOfData,
    );
  }

  DateTime get _selectedDay => calendarCont.selectedDay;

  Future _showReflectedDialog() async {
    await showFDialog(
      title: fetchedTitle,
      content: FText(fetchedText, maxLines: 0),
      type: DialogType.mono,
    );
  }

  void _fetchData(FType type) async {
    await _showReflectedDialog();
    await HealthDataCont.setOneDayRecordByType(type, _selectedDay);
    await onRefresh();

    if (getSpendingFPoint(type) == 0) return;
    FPointCont.to.spend(getSpendingFPoint(type), 'fetch-data-${type.name}');
  }

  void _fetchAllTypeOfData() async {
    await _showReflectedDialog();
    await HealthDataCont.setOneDayRecordByType(FType.distance, _selectedDay);
    await HealthDataCont.setOneDayRecordByType(FType.height, _selectedDay);
    await onRefresh();

    if (getSpendingFPoint() == 0) return;
    FPointCont.to.spend(getSpendingFPoint(), 'fetch-data-all');
  }

  int getSpendingFPoint([FType? type]) {
    int diff = today.difference(_selectedDay).inDays;
    bool dis = calendarCont.typeHasUnreflectedAmount(FType.distance);
    bool hei = calendarCont.typeHasUnreflectedAmount(FType.height);

    int w = type == null && dis && hei ? 2 : 1;
    if (diff < 2) return 0;
    return w * min(300 + 50 * (max(diff - 1, 0)), 10000);
  }

  @override
  String get loadKey => 'calendar';


  @override
  Future load() async => await calendarCont.init();

}