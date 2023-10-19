import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RankingPageCont extends PageCont {
  static RankingPageCont get to => Get.find<RankingPageCont>();

  static RankingCont get rankingCont => RankingCont.to;
  static FPointCont get fPointCont => FPointCont.to;

  @override
  String get loadKey => 'ranking';

  String get appBarTitle => LangCont.tr('appbar.ranking');

  String get _dialogTr => 'ranking.dialog';

  String get fPointTitle => LangCont.tr('$_dialogTr.fpoint.title');
  String get fPointText => LangCont.tr(
    '$_dialogTr.fpoint.text',
    namedArgs: {'duration': rankingCont.getLeftTime(selectedDate).format.trim()},
  );
  String get receivedText => LangCont.tr('$_dialogTr.fpoint.received-text');

  String get earnedTitle => LangCont.tr('$_dialogTr.earned.title');
  String get earnedText => LangCont.tr(
    '$_dialogTr.earned.text',
    namedArgs: {'point': '${rankingCont.estimatedFPoint}'},
  );

  FUser get _logged => AuthCont.logged!;

  final carouselCont = CarouselController();

  final _pageIndex = 0.obs;
  int get pageIndex => _pageIndex.value;
  int get count => _logged.rankings[rankingCont.period]?.length ?? 0;
  bool get finished => pageIndex < count - 1;

  final _selectedDate = today.obs;
  DateTime get selectedDate => _selectedDate.value;

  void gotoLastPage() {
    if (FRoute.currentPage != '/home/ranking') return;
    int lastPageIndex = count - 1;
    carouselCont.jumpToPage(lastPageIndex);
    _pageIndex(lastPageIndex);
    setSelectedDate(lastPageIndex);
    rankingCont.calculateFPoints();
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    _pageIndex(index);
    setSelectedDate(index);
    rankingCont.calculateFPoints();
  }

  void setSelectedDate(int index) {
    Period p = rankingCont.period;
    List<RankingData> data = rankingCont.getRankings(p);
    DateTime time = data[index].date;
    _selectedDate(time);
  }

  @override
  Future load() async {
    await rankingCont.init();
  }

  bool get receivable {
    bool finished = rankingCont.finished;
    bool received = rankingCont.received;
    return finished && !received;
  }

  void fPointButtonPressed() {
    String? rightText;
    Color? rightColor;

    if (receivable) {
      rightText = '${rankingCont.estimatedFPoint} FP';
      rightColor = FTheme.point;
    }

    showFDialog(
      title: fPointTitle,
      content: Column(
        children: [
          FPointAmountWidget(amount: rankingCont.estimatedFPoint),
          FText(
            rankingCont.calculator.pointText,
            maxLines: 0,
            color: FTheme.outline,
            style: FTheme.bodyLarge,
          ),
          Obx(() {
            String? contentText;
            if (rankingCont.received) contentText = receivedText;
            if (!rankingCont.finished) contentText = fPointText;

            if (contentText == null) return Container();

            return FText(
              contentText,
              color: FTheme.comment,
              style: FTheme.commentStyle,
            );
          }),
        ].separateH(height: 10.0.h),
      ),
      type: receivable
          ? DialogType.bi
          : DialogType.mono,
      rightText: rightText,
      rightBackgroundColor: rightColor,
      rightPressed: earnFPoints,
    );
  }

  void earnFPoints() async {
    if (!receivable) return;

    await showFDialog(
      title: earnedTitle,
      content: FTexts(
        earnedText,
        style: FTheme.bodyLarge,
        textColor: FTheme.outline,
        highlightColor: FTheme.point,
        wordWrap: true,
      ),
      type: DialogType.mono,
    );

    rankingCont.receivePoint();
    int point = rankingCont.estimatedFPoint;
    Period period = rankingCont.period;
    fPointCont.earn(point, 'ranking-${period.name}');
  }
}