import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RankingPage extends FPage {
  const RankingPage({super.key});

  @override
  FPageState<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends FPageState<RankingPage> {
  @override
  RankingPageCont get cont => RankingPageCont.to;
  RankingCont get rankingCont => RankingCont.to;
  HomePageCont get homeCont => HomePageCont.to;

  Widget _buildRankingIndividualGraphWidget(
    BuildContext context,
    FUser user,
    DateTime date,
  ) {
    FType type = homeCont.activeType;
    bool isMe = user.uid == AuthCont.uid;

    int rank = 1 + rankingCont.getRankOf(rankingCont.period, type, user.uid, date);
    String centerText = rankingCont.getAmountTextOf(type, user.uid, date, scaling: false);
    double percent = rankingCont.getPercentOf(type, user.uid, date);
    bool finished = rankingCont.getLeftTime(date) == Duration.zero;

    Color progressColor = ThemeCont.to.unselected;

    if (isMe) {
      progressColor = finished
          ? ThemeCont.to.selected
          : homeCont.activeType.color;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RankIcon(rank: rank),
            SizedBox(width: 10.0.w),
            FText(user.nickname, style: ThemeCont.to.bodyLarge),
          ],
        ),
        SizedBox(height: 5.0.h),
        FLinearPercentIndicator(
          centerText: centerText,
          percent: percent,
          backgroundColor: Colors.transparent,
          animation: true,
          animateFromLastPercent: true,
          progressColor: progressColor,
        ),
      ],
    );
  }

  Widget _buildPeriodTabWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.0.w, 10.0.h, 28.0.w, .0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: Period.values.map<Widget>((period) {
              bool isSelected = period == rankingCont.period;
              return FTextButton(
                text: period.locale.capitalize!,
                bold: isSelected,
                style: ThemeCont.to.bodyLarge,
                textColor: isSelected
                    ? homeCont.activeType.color
                    : ThemeCont.to.comment,
                onPressed: () => rankingCont.changePeriod(period),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildDateIndicatorWidget(BuildContext context, RankingData ranking) {
    double percent = rankingCont.getLeftPercent(ranking.date);
    bool finished = percent == 1.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FText(
              dateToString('yyyy.MM.dd', rankingCont.getStartTime(ranking.date))!,
              color: ThemeCont.to.comment,
              style: ThemeCont.to.commentStyle,
            ),
            FText(
              rankingCont.getLeftTime(ranking.date).left,
              color: ThemeCont.to.comment,
              style: ThemeCont.to.commentStyle,
            ),
          ],
        ),
        SizedBox(height: 5.0.h),
        FLinearPercentIndicator(
          percent: percent,
          backgroundColor: ThemeCont.to.background,
          progressColor: finished
              ? ThemeCont.to.unselected
              : ThemeCont.colorA,
          height: 10.0.h,
        ),
        SizedBox(height: 30.0.h),
      ],
    );
  }

  CarouselOptions get _options => CarouselOptions(
    height: PageCont.size.height * .55,
    viewportFraction: 1.0,
    enableInfiniteScroll: false,
    initialPage: cont.count,
    onPageChanged: cont.onPageChanged,
  );

  Widget _buildRankingCarouselWidget(BuildContext context) {
    return Obx(() {
      Period p = rankingCont.period;
      return CarouselSlider(
        carouselController: cont.carouselCont,
        items: rankingCont.getRankings(p).map((ranking) {
          FType type = homeCont.activeType;
          List<String> uids = rankingCont.getRanks(p, type, ranking.date);
          List<Widget> children = [];

          for (int i = 0; i < uids.length; i++) {
            FUser user = rankingCont.getUser(uids[i]);
            Widget widget = _buildRankingIndividualGraphWidget(context, user, ranking.date);
            children.add(widget);
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.0.w),
            child: FCard(
              child: SizedBox(
                height: PageCont.size.height * .5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDateIndicatorWidget(context, ranking),
                      ...children.separateH(height: 10.0.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        options: _options,
      );
    });
  }

  Widget _buildFPointButton(BuildContext context) {
    return Obx(() => FPointButton(
      amount: rankingCont.estimatedFPoint,
      received: rankingCont.received,
      finished: rankingCont.finished,
      onPressed: cont.fPointButtonPressed,
    ));
  }

  Widget _buildRankingWidget(BuildContext context) {
    return Column(
      children: [
        _buildPeriodTabWidget(context),
        SizedBox(height: 10.0.h),
        _buildRankingCarouselWidget(context),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      autoPadding: false,
      appBar: FPointAppBar(text: cont.appBarTitle),
      body: _buildRankingWidget(context),
      bottomWidget: _buildFPointButton(context),
    );
  }

}