import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:fitween/src/view/widget/widget/calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

class CalendarPage extends FPage {
  const CalendarPage({super.key});

  @override
  FPageState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends FPageState<CalendarPage> {
  @override
  CalendarPageCont get cont => CalendarPageCont.to;
  CalendarCont get calendarCont => CalendarCont.to;
  HomePageCont get homePageCont => HomePageCont.to;

  CalendarStyle get _calendarStyle {
    return CalendarStyle(
      isTodayHighlighted: true,
      cellMargin: EdgeInsets.all(1.0.r),
      cellAlignment: Alignment.topCenter,
      cellPadding: EdgeInsets.only(top: 5.0.h),
    );
  }

  Widget _buildBuilder(
    BuildContext context, {
    required DateTime date,
    Color? color,
    TextStyle? style,
    BoxDecoration? decoration,
  }) {
    date = date.ignoreTime;
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          padding: EdgeInsets.only(top: 5.0.h),
          margin: EdgeInsets.all(1.0.r),
          alignment: Alignment.topCenter,
          decoration: decoration,
          child: FText('${date.day}',
            color: color,
            style: style,
          ),
        ),
        if (calendarCont.dateHasUnreflectedAmount(date))
        Container(
          width: 5.0.r, height: 5.0.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: FTheme.point,
          ),
        ),
      ],
    );
  }

  Widget? _defaultBuilder(BuildContext context, DateTime date, DateTime event) {
    Color textColor = calendarCont.isAllFinished(date)
        ? FTheme.colorA : FTheme.text;
    return _buildBuilder(
      context,
      date: date,
      color: textColor,
      style: FTheme.bodyMedium,
    );
  }

  Widget? _todayBuilder(BuildContext context, DateTime date, DateTime event) {
    Color textColor = calendarCont.isAllFinished(today)
        ? FTheme.colorA : FTheme.textAlt;
    BoxDecoration decoration = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: FTheme.text, width: 3.0.r),
    );
    return _buildBuilder(
      context,
      date: date,
      color: textColor,
      style: FTheme.bodyLarge,
      decoration: decoration,
    );
  }

  Widget? _selectedBuilder(BuildContext context, DateTime date, DateTime event) {
    Color textColor = calendarCont.isAllFinished(calendarCont.selectedDay)
        ? FTheme.colorA : FTheme.backgroundAlt;
    BoxDecoration decoration = BoxDecoration(
      color: FTheme.text,
      shape: BoxShape.circle,
    );
    return _buildBuilder(
      context,
      date: date,
      color: textColor,
      style: FTheme.bodyLarge,
      decoration: decoration,
    );
  }

  Widget _markerBuilder(BuildContext context, DateTime date, List<CalendarEvent> event) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0.h),
      child: CalendarDots(
        completedTypes: calendarCont.completedTypes(date),
        startedTypes: calendarCont.startedTypes(date),
      ),
    );
  }

  HeaderStyle get _headerStyle => HeaderStyle(
    formatButtonVisible: false,
    headerPadding: EdgeInsets.zero,
    titleCentered: true,
    titleTextStyle: FTheme.titleMedium!
        .copyWith(color: FTheme.text),
    leftChevronIcon: Icon(
      Icons.chevron_left,
      color: FTheme.textAlt,
    ),
    rightChevronIcon: Icon(
      Icons.chevron_right,
      color: FTheme.textAlt,
    ),
  );

  Widget _buildTableCalendarWidget(BuildContext context) {
    return Obx(() => TableCalendar<CalendarEvent>(
      firstDay: calendarCont.firstDay,
      lastDay: calendarCont.lastDay,
      focusedDay: calendarCont.focusedDay,
      selectedDayPredicate: calendarCont.selectedDayPredicate,
      calendarFormat: CalendarFormat.month,
      eventLoader: calendarCont.getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      rowHeight: 42.0.h,
      daysOfWeekHeight: 30.0.h,
      pageJumpingEnabled: true,
      calendarStyle: _calendarStyle,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: _defaultBuilder,
        todayBuilder: _todayBuilder,
        selectedBuilder: _selectedBuilder,
        markerBuilder: _markerBuilder,
      ),
      onDaySelected: calendarCont.selectDay,
      headerStyle: _headerStyle,
      locale: LangCont.locale,
    ));
  }

  Widget _buildCalendarCardWidget(BuildContext context) {
    return FCard(child: _buildTableCalendarWidget(context));
  }



  Widget _buildDayRecordGraphWidget(BuildContext context, FType type) {
    return Obx(() {
      double forePercent = calendarCont.getPercent(type);
      num amount = calendarCont.getAmount(type);
      num goal = calendarCont.getGoal(type);

      Color color = forePercent == 1.0 ? type.color : FTheme.unselected;
      if (calendarCont.allCompleted) color = FTheme.colorA;

      DateTime date = calendarCont.selectedDay;
      num unreflected = calendarCont.getUnreflectedAmount(type, date);
      double backPercent = (unreflected + amount) / goal;

      if (forePercent >= 1.0 && unreflected != 0) forePercent = .95;

      return ScalePressableWidget(
        onPressed: () => cont.linearPercentIndicatorWidgetPressed(type),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FOverlappedLinearPercentIndicator(
              forePercent: forePercent,
              backPercent: backPercent,
              backgroundColor: Colors.transparent,
              foreProgressColor: color,
              backProgressColor: FTheme.point.withOpacity(.7),
              animation: true,
              animateFromLastPercent: true,
            ),
            FTexts(
              calendarCont.getDayRecordGraphTextByType(type),
              style: FTheme.bodyMedium,
              textColor: color,
              highlightStyle: FTheme.bodyMedium?.copyWith(
                color: FTheme.point,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDayRecordWidget(BuildContext context) {
    return Column(
      children: FType.activeValues.map((type) {
        return _buildDayRecordGraphWidget(context, type);
      }).separateH(height: 5.0.h),
    );
  }

  Widget _buildDayRecordsWidget(BuildContext context) {
    return Obx(() {
      Widget title = FText(calendarCont.dayRecordGraphCardTitle);
      Widget child = _buildDayRecordWidget(context);

      if (calendarCont.dateHasUnreflectedAmount(calendarCont.selectedDay)) {
        return FCard(
          icon: const Icon(Icons.info_outline),
          iconColor: FTheme.point,
          pressMode: FCardPressMode.icon,
          onPressed: cont.reflectInformationButtonPressed,
          title: title,
          child: Column(
            children: [
              child,
              SizedBox(height: 40.0.h),
              FButton(
                text: cont.fetchButtonText,
                stretch: true,
                backgroundColor: FTheme.point,
                onPressed: cont.fetchButtonPressed,
              ),
            ],
          ),
        );
      }
      return FCard(title: title, child: child);
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return FRefreshScaffold(
      refreshController: RefreshController(),
      onRefresh: calendarCont.init,
      height: PageCont.size.height * 1.2,
      appBar: FPointAppBar(text: cont.appBarTitle),
      body: Column(
        children: [
          _buildCalendarCardWidget(context),
          SizedBox(height: 20.0.h),
          _buildDayRecordsWidget(context),
        ],
      ),
    );
  }
}