import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:fitween/src/view/page/abs/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:fitween/src/view/widget/widget/calendar.dart';
import 'package:fitween/src/view/widget/widget/carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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

  Widget _buildMarbleCarouselWidget(BuildContext context) {
    return Obx(() => CircularCarousel(
      width: PageCont.size.width * (PageCont.isPortrait ? 1.2 : .6),
      height: 100.0.h,
      itemSize: 200.0.r,
      onChanged: cont.onChanged,
      leftWidget: SvgPicture.asset(cont.leftArrowAsset),
      rightWidget: SvgPicture.asset(cont.rightArrowAsset),
      children: FType.activeValues
          .map((type) => Marble(
        type: type,
        smile: type == cont.activeType,
        tagVisible: true,
      )).toList(),
    ));
  }

  Widget _buildDayCalendarWidget(BuildContext context, DateTime date) {
    bool isToday = date.wd == today.wd;
    Color backgroundColor = isToday
        ? FTheme.selected
        : Colors.transparent;
    return Container(
      width: 38.0.r,
      height: 38.0.r,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FText(
            date.wd.short,
            style: FTheme.titleMedium,
            color: isToday
                ? FTheme.backgroundAlt
                : FTheme.comment,
          ),
          CalendarDots(
            completedTypes: calendarCont.completedTypes(date),
            startedTypes: calendarCont.startedTypes(date),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCalendarWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        Weekday.values.length, (i) => _buildDayCalendarWidget(
        context, today.firstDayOfWeek.add(i.d),
      )),
    );
  }

  Widget _buildRecordCardWidget(BuildContext context) {
    return FCard(
      title: FText(cont.recordCardTitle, style: FTheme.cardTitleStyle),
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

    List<num> amounts = rankingCont.getAmounts(type);
    int rank = 1 + amounts.indexWhere((a) {
      return a == rankingCont.getAmountOf(type, user.uid);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RankIcon(rank: rank),
            SizedBox(width: 10.0.w),
            FText(user.nickname, style: FTheme.bodyLarge),
          ],
        ),
        SizedBox(height: 5.0.h),
        FLinearPercentIndicator(
          percent: rankingCont.getPercentOf(type, user.uid),
          backgroundColor: Colors.transparent,
          progressColor: isMe
              ? cont.activeType.color
              : FTheme.unselected,
        ),
      ],
    );
  }

  Widget _buildRankingCardContentWidget(BuildContext context) {
    return Obx(() {
      FType type = cont.activeType;
      List<String> uids = rankingCont.getRanksFocusedOnMe(type, 3);
      List<Widget> children = [];
      for (int i = 0; i < uids.length; i++) {
        FUser user = rankingCont.getUser(uids[i]);
        Widget widget = _buildRankingIndividualGraphWidget(context, user);
        children.add(widget);
      }

      return Column(children: children.separate(10.0.h));
    });
  }

  Widget _buildRankingCardWidget(BuildContext context) {
    return FCard(
      title: FText(cont.rankingCardTitle, style: FTheme.cardTitleStyle),
      onPressed: cont.onRankingCardPressed,
      child: _buildRankingCardContentWidget(context),
    );
  }

  EdgeInsets get _padding => EdgeInsets.symmetric(
    horizontal: 28.0.w, vertical: 28.0.h,
  );

  @override
  void initState() {
    super.initState();
    cont.init();
  }

  @override
  Widget buildPage(BuildContext context) {
    return FRefreshScaffold(
      autoPadding: false,
      refreshController: cont.refreshCont,
      onRefresh: cont.init,
      body: Stack(
        children: [
          _buildMarbleCarouselWidget(context),
          Padding(
            padding: _padding,
            child: Column(
              children: [
                SizedBox(height: 250.0.h),
                _buildRecordCardWidget(context),
                SizedBox(height: 20.0.h),
                _buildRankingCardWidget(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Marble extends FWidget {
  const Marble({
    super.key,
    required this.type,
    this.smile = false,
    this.tagVisible = false,
  });

  final FType type;
  final bool smile;
  final bool tagVisible;

  @override
  FWidgetState<FWidget> createState() => _MarbleState();
}

class _MarbleState extends FWidgetState<Marble> {
  static const asset = 'assets/image/page/home/marble.svg';

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      width: 200.0.r,
      height: 200.0.r,
      decoration: BoxDecoration(
        color: widget.type.color,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: widget.smile
                ? SvgPicture.asset(asset)
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0.h),
            child: widget.tagVisible ? FTag(widget.type.locale.capitalize!,
              backgroundColor: FTheme.achro90.withOpacity(.3),
              textColor: FTheme.achro90,
            ) : Container(),
          ),
        ],
      ),
    );
  }
}
