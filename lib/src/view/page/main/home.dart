import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:fitween/src/view/widget/widget/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends FPage {
  const HomePage({super.key});

  @override
  FPageState createState() => _HomePageState();
}

class _HomePageState extends FPageState {
  @override
  HomePageCont get cont => HomePageCont.to;
  CalendarCont get calendarCont => cont.calendarCont;
  RankingCont get rankingCont => cont.rankingCont;

  double get _size => PageCont.size.width * .1;

  Widget _buildHeightUpDownButtonWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FIconButton(
          icon: const Icon(Icons.arrow_drop_up),
          onPressed: cont.countHeightUpButtonPressed,
          iconColor: ThemeCont.achro95,
        ),
        FIconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: cont.countHeightDownButtonPressed,
          iconColor: ThemeCont.achro95,
        ),
      ],
    );
  }

  Widget _buildMarbleCarouselWidget(BuildContext context) {
    return Obx(() => CircularCarousel(
      width: PageCont.size.width * (PageCont.isPortrait ? 1.2 : .6),
      height: 100.0.h,
      itemSize: 180.0.r,
      onChanged: cont.onChanged,
      defaultIndex: cont.activeIndex,
      leftWidget: SvgPicture.asset(cont.leftArrowAsset),
      rightWidget: SvgPicture.asset(cont.rightArrowAsset),
      children: FType.activeValues.map((type) {
        bool isActive = type == cont.activeType;
        return Stack(
          alignment: Alignment.center,
          children: [
            Marble(
              type: type,
              center: isActive ? FTexts(
                cont.marbleCenterText,
                textColor: ThemeCont.achro90,
                style: ThemeCont.to.bodyMedium,
                highlightStyle: ThemeCont.to.displayMedium
                    ?.copyWith(color: ThemeCont.achro90),
              ) : null,
              smile: isActive,
              tagVisible: isActive,
              met: calendarCont.allCompleted,
              selected: cont.activeType == type,
            ),
            if (!LoadingCont.to.loading && isActive && type == FType.height && Platform.isAndroid)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeightUpDownButtonWidget(context),
                Padding(
                  padding: EdgeInsets.only(top: 20.0.r, right: 20.0.r),
                  child: FIconButton(
                    icon: const Icon(Icons.info_outline),
                    iconColor: ThemeCont.achro95,
                    onPressed: cont.heightInfoButtonPressed,
                  ),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    ));
  }

  Widget _buildNoticeWidget(BuildContext context) {
    return const NoticeWidget();
  }


  Widget _buildGiftCardContentWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const GiftWidget(),
        SizedBox(width: 10.0.w),
        FText(
          cont.giftCardText,
          color: ThemeCont.to.background,
          bold: true,
        ),
      ],
    );
  }

  Widget _buildGiftCardWidget(BuildContext context) {
    return Obx(() {
      if (cont.hasGiftReceived) return Container();
      return PulseWidget(
        onPressed: cont.giftCardPressed,
        child: Container(
          padding: EdgeInsets.all(20.0.r),
          decoration: BoxDecoration(
            color: ThemeCont.colorA,
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          child: _buildGiftCardContentWidget(context),
        ),
      );
    });
  }

  Widget _buildDayCalendarWidget(BuildContext context, DateTime date) {
    return Obx(() {
      bool selected = date.isAtSameMomentAs(calendarCont.selectedDay);
      bool passed = !date.isAfter(today);
      bool isToday = date.isAtSameMomentAs(today);
      void onTap() => calendarCont.selectDay(date, date);
      String dayText = '${date.day}';
      if (date.day == 1) dayText = '${date.month}/$dayText';

      Color textColor = Colors.transparent;
      if (passed) textColor = ThemeCont.to.comment;
      if (selected) textColor = ThemeCont.to.background;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: _size,
          height: _size,
          padding: EdgeInsets.all(1.0.r),
          decoration: BoxDecoration(
            color: selected
                ? ThemeCont.to.selected
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isToday
                  ? ThemeCont.to.selected
                  : Colors.transparent,
              width: 3.0.r,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FText(
                dayText,
                style: ThemeCont.to.bodyMedium,
                color: textColor,
              ),
              CalendarDots(
                completedTypes: calendarCont.completedTypes(date),
                startedTypes: calendarCont.startedTypes(date),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildWeeklyCalendarHeaderWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: Weekday.values.map((wd) => SizedBox(
        width: _size,
        child: FText(
          wd.short,
          style: ThemeCont.to.bodyMedium,
          color: ThemeCont.to.comment,
          align: TextAlign.center,
        ),
      )).toList(),
    );
  }

  Widget _buildWeeklyCalendarWidget(BuildContext context) {
    return CarouselSlider(
      carouselController: cont.carouselCont,
      items: List.generate(
        cont.carouselCount, (i) => Column(
          children: [
            _buildWeeklyCalendarHeaderWidget(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                Weekday.values.length, (j) => _buildDayCalendarWidget(
                  context, cont.firstDay.firstDayOfWeek.add((i * 7 + j).d).ignoreTime,
                ),
              ),
            ),
          ],
        ),
      ),
      options: CarouselOptions(
        viewportFraction: 1.0,
        height: 68.0.h,
        enableInfiniteScroll: false,
        onPageChanged: cont.onPageChanged,
      ),
    );
  }

  Widget _buildViewTodayButtonWidget(BuildContext context) {
    return Obx(() {
      return calendarCont.isToday && cont.isLastPage
          ? Container() : Padding(
        padding: EdgeInsets.only(left: 10.0.r),
        child: FTextButton(
          text: cont.viewTodayText,
          shrinkWrap: true,
          style: ThemeCont.to.bodyMedium,
          textColor: ThemeCont.to.comment,
          onPressed: cont.selectToday,
        ),
      );
    });
  }

  Widget _buildRecordCardWidget(BuildContext context) {
    return FCard(
      title: Row(
        children: [
          FText(cont.recordCardTitle, style: ThemeCont.to.cardTitleStyle),
          _buildViewTodayButtonWidget(context),
        ],
      ),
      pressMode: FCardPressMode.icon,
      onPressed: cont.onRecordCardPressed,
      child: _buildWeeklyCalendarWidget(context),
    );
  }

  Widget _buildRankingIndividualGraphWidget(
    BuildContext context,
    FUser user,
  ) {
    FType type = cont.activeType;
    bool isMe = user.uid == AuthCont.uid;
    DateTime startTime = rankingCont.getStartTime(today);

    int rank = 1 + rankingCont.getRankOf(rankingCont.period, type, user.uid, startTime);

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
          centerText: rankingCont.getAmountTextOf(type, user.uid, startTime),
          percent: rankingCont.getPercentOf(type, user.uid, startTime),
          backgroundColor: Colors.transparent,
          animation: true,
          animateFromLastPercent: true,
          progressColor: isMe
              ? cont.activeType.color
              : ThemeCont.to.unselected,
        ),
      ],
    );
  }

  Widget _buildRankingCardContentHeaderWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: Period.values.map((period) {
            bool isSelected = period == rankingCont.period;
            return FTextButton(
              text: period.locale.capitalize!,
              bold: isSelected,
              shrinkWrap: true,
              style: ThemeCont.to.bodyLarge,
              textColor: isSelected
                  ? cont.activeType.color
                  : ThemeCont.to.comment,
              onPressed: () => rankingCont.changePeriod(period),
            );
          }).toList(),
        ),
        SizedBox(height: 10.0.h),
      ],
    );
  }

  Widget _buildRankingCardContentWidget(BuildContext context) {
    return Obx(() {
      FType type = cont.activeType;
      List<String> uids = rankingCont.getRanksFocusedOnMe(type, 3);
      List<Widget> children = [];

      children.add(_buildRankingCardContentHeaderWidget(context));

      for (int i = 0; i < uids.length; i++) {
        FUser user = rankingCont.getUser(uids[i]);
        Widget widget = _buildRankingIndividualGraphWidget(context, user);
        children.add(widget);
      }

      return rankingCont.hasFriend
          ? Column(children: children.separateH(height: 10.0.h))
          : Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.h),
          child: FText(
            cont.noFriendsText,
            color: ThemeCont.to.comment,
            style: ThemeCont.to.titleSmall,
            align: TextAlign.center,
            maxLines: 2,
          ),
        ),
      );
    });
  }

  Widget _buildRankingCardWidget(BuildContext context) {
    return FCard(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FText(cont.rankingCardTitle, style: ThemeCont.to.cardTitleStyle),
          SizedBox(width: 10.0.w),
          Obx(() => FText(
            rankingCont.getLeftTime(rankingCont.getStartTime(today)).left,
            style: ThemeCont.to.bodyMedium,
            color: ThemeCont.to.comment,
          )),
        ],
      ),
      onPressed: cont.onRankingCardPressed,
      pressMode: FCardPressMode.icon,
      child: _buildRankingCardContentWidget(context),
    );
  }

  EdgeInsets get _padding => EdgeInsets.symmetric(horizontal: 28.0.w);

  @override
  Widget buildPage(BuildContext context) {
    return FMainScaffold(
      autoPadding: false,
      refreshController: RefreshController(),
      onRefresh: cont.onRefresh,
      height: PageCont.size.height * 1.1,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: 250.0.h),
                _buildNoticeWidget(context),
                Padding(
                  padding: _padding,
                  child: Column(
                    children: [
                      _buildGiftCardWidget(context),
                      SizedBox(height: 20.0.h),
                      _buildRecordCardWidget(context),
                      SizedBox(height: 20.0.h),
                      _buildRankingCardWidget(context),
                      SizedBox(height: 20.0.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildMarbleCarouselWidget(context),
        ],
      ),
    );
  }
}

class Marble extends FWidget {
  const Marble({
    super.key,
    required this.type,
    this.center,
    this.smile = false,
    this.tagVisible = false,
    this.met = false,
    this.selected = false,
  });

  final FType type;
  final Widget? center;
  final bool smile;
  final bool tagVisible;
  final bool met;
  final bool selected;

  @override
  FWidgetState<FWidget> createState() => _MarbleState();
}

class _MarbleState extends FWidgetState<Marble> {
  static const asset = 'assets/image/page/home/marble.svg';

  LoadingCont get cont => LoadingCont.to;

  Color get _color {
    Color color = cont.loading
        ? cont.color
        : widget.type.color;

    final tintColor = ThemeCont.achro95.withOpacity(.15);

    if (widget.met) {
      color = ThemeCont.colorA;
      if (!widget.selected) color = Color.alphaBlend(tintColor, color);
      return color;
    }
    return color;
  }

  Color get _tagColor => widget.met
      ? widget.type.color
      : ThemeCont.achro90.withOpacity(.3);

  @override
  Widget buildWidget(BuildContext context) {
    return Obx(() => Container(
      width: 180.0.r,
      height: 180.0.r,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
      ),
      child: cont.loading ? null : Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: widget.smile
                ? SvgPicture.asset(asset)
                : Container(),
          ),
          Positioned(
            bottom: 10.0.h,
            child: widget.tagVisible
                ? FTypeTag(type: widget.type, color: _tagColor)
                : Container(),
          ),
          Container(child: widget.center),
        ],
      ),
    ));
  }
}