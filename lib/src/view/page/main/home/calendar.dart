import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
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

  CalendarStyle get _calendarStyle {
    TextStyle? selectedTextStyle = FTheme.bodyLarge?.copyWith(
      color: calendarCont.isAllFinished(calendarCont.selectedDay)
          ? FTheme.colorA
          : FTheme.backgroundAlt,
    );
    TextStyle? todayTextStyle = FTheme.bodyLarge?.copyWith(
      color: calendarCont.isAllFinished(today)
          ? FTheme.colorA
          : FTheme.textAlt,
    );

    return CalendarStyle(
      isTodayHighlighted: true,
      selectedDecoration: BoxDecoration(
        color: FTheme.text,
        shape: BoxShape.circle,
      ),
      selectedTextStyle: selectedTextStyle!,
      todayDecoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: FTheme.text, width: 3.0.r),
      ),
      todayTextStyle: todayTextStyle!,
      cellMargin: EdgeInsets.all(2.0.r),
      cellAlignment: Alignment.center,
    );
  }

  Widget? _defaultBuilder(BuildContext context, DateTime date, DateTime event) {
    return Container(
      alignment: Alignment.center,
      child: FText('${date.day}',
        color: calendarCont.isAllFinished(date)
            ? FTheme.colorA
            : FTheme.text,
        style: FTheme.bodyMedium,
      ),
    );
  }

  Widget _markerBuilder(BuildContext context, DateTime date, List<CalendarEvent> event) {
    return CalendarDots(
      completedTypes: calendarCont.completedTypes(date), 
      startedTypes: calendarCont.startedTypes(date),
    );
  }

  HeaderStyle get _headerStyle => HeaderStyle(
    formatButtonVisible: false,
    headerPadding: EdgeInsets.zero,
    titleCentered: true,
    titleTextStyle: FTheme.titleMedium!
        .apply(color: FTheme.text),
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
        markerBuilder: _markerBuilder,
      ),
      onDaySelected: calendarCont.selectDay,
      headerStyle: _headerStyle,
      locale: LangCont.locale,
    ));
  }

  Widget _buildCalendarCardWidget(BuildContext context) {
    return FCard(
      child: _buildTableCalendarWidget(context),
    );
  }

  Widget _buildDayRecordGraphWidget(BuildContext context, FType type) {
    double percent = calendarCont.getPercent(type);
    Color color = percent == 1.0
        ? type.color
        : FTheme.unselected;
    if (calendarCont.allCompleted) color = FTheme.colorA;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FLinearPercentIndicator(
          percent: percent,
          backgroundColor: Colors.transparent,
          progressColor: color,
          animation: true,
          animateFromLastPercent: true,
        ),
        FText(
          calendarCont.getDayRecordGraphTextByType(type),
          style: FTheme.bodyMedium,
          color: color,
        ),
      ],
    );
  }

  Widget _buildDayRecordWidget(BuildContext context) {
    return Column(
      children: FType.activeValues.map((type) {
        return _buildDayRecordGraphWidget(context, type);
      }).separateH(height: 5.0.h),
    );
  }

  Widget _buildDayRecordsWidget(BuildContext context) {
    return Obx(() => FCard(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FText(calendarCont.dayRecordGraphCardTitle),
          Row(
            children: [
              FText('${calendarCont.getInsufficientAmountText(FType.distance)}'),
              SizedBox(width: 10.0.w),
              FText('${calendarCont.getInsufficientAmountText(FType.height)}'),
            ],
          ),
        ],
      ),
      child: _buildDayRecordWidget(context),
    ));
  }

  @override
  Widget buildPage(BuildContext context) {
    return FRefreshScaffold(
      refreshController: RefreshController(),
      onRefresh: calendarCont.init,
      appBar: FAppBar(
        text: cont.appBarText,
        backPressed: FRoute.toHome,
      ),
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