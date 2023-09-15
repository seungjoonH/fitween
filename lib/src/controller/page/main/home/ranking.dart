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

  @override
  String get loadKey => 'ranking';

  String get appBarTitle => LangCont.tr('appbar.ranking');
  String get fPointDialogTitle => LangCont.tr('ranking.fpoint-dialog.title');
  String get fPointDialogContent => LangCont.tr(
    'ranking.fpoint-dialog.content',
    args: [rankingCont.getLeftTime(selectedDate).format],
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
    _pageIndex(lastPageIndex);
    carouselCont.jumpToPage(lastPageIndex);
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    _pageIndex(index);
    Period p = rankingCont.period;
    _selectedDate(p.getBeforeDate(p.getCurrentDate(today), count - index - 1));
  }

  @override
  Future load() async {}

  void fPointButtonPressed() {
    showFDialog(
      title: fPointDialogTitle,
      content: Column(
        children: [
          FPointAmountWidget(amount: rankingCont.estimatedFPoint),
          SizedBox(height: 20.0.h),
          Obx(() => FText(
            fPointDialogContent,
            maxLines: 0,
            color: FTheme.comment,
          )),
        ],
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }
}