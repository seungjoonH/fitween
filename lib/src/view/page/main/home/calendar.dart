import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:fitween/src/view/widget/widget/calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
            color: ThemeCont.to.point,
          ),
        ),
      ],
    );
  }

  Widget? _defaultBuilder(BuildContext context, DateTime date, DateTime event) {
    Color textColor = calendarCont.isAllFinished(date)
        ? ThemeCont.colorA : ThemeCont.to.text;
    return _buildBuilder(
      context,
      date: date,
      color: textColor,
      style: ThemeCont.to.bodyMedium,
    );
  }

  Widget? _todayBuilder(BuildContext context, DateTime date, DateTime event) {
    Color textColor = calendarCont.isAllFinished(today)
        ? ThemeCont.colorA : ThemeCont.to.textAlt;
    BoxDecoration decoration = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: ThemeCont.to.text, width: 3.0.r),
    );
    return _buildBuilder(
      context,
      date: date,
      color: textColor,
      style: ThemeCont.to.bodyLarge,
      decoration: decoration,
    );
  }

  Widget? _selectedBuilder(BuildContext context, DateTime date, DateTime event) {
    Color textColor = calendarCont.isAllFinished(calendarCont.selectedDay)
        ? ThemeCont.colorA : ThemeCont.to.backgroundAlt;
    BoxDecoration decoration = BoxDecoration(
      color: ThemeCont.to.text,
      shape: BoxShape.circle,
    );
    return _buildBuilder(
      context,
      date: date,
      color: textColor,
      style: ThemeCont.to.bodyLarge,
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
    titleTextStyle: ThemeCont.to.titleSmall!
        .copyWith(color: ThemeCont.to.text),
    leftChevronIcon: Icon(
      Icons.chevron_left,
      color: ThemeCont.to.textAlt,
    ),
    rightChevronIcon: Icon(
      Icons.chevron_right,
      color: ThemeCont.to.textAlt,
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
    if (calendarCont.entirelyReflected) {
      return FCard(child: _buildTableCalendarWidget(context));
    }

    return FCard(
      rightTopWidget: Icon(
        Icons.refresh,
        color: ThemeCont.to.point,
      ),
      iconColor: ThemeCont.to.point,
      pressMode: FCardPressMode.icon,
      onPressed: cont.refreshButtonPressed,
      child: _buildTableCalendarWidget(context),
    );
  }

  Widget _buildDayRecordGraphWidget(BuildContext context, FType type) {
    return Obx(() {
      double forePercent = calendarCont.getPercent(type);
      num amount = calendarCont.getAmount(type);
      num goal = calendarCont.getGoal(type);

      Color color = forePercent == 1.0 ? type.color : ThemeCont.to.unselected;
      if (calendarCont.allCompleted) color = ThemeCont.colorA;

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
              backProgressColor: ThemeCont.to.point.withOpacity(.7),
              animation: true,
              animateFromLastPercent: true,
            ),
            FTexts(
              calendarCont.getDayRecordGraphTextByType(type),
              style: ThemeCont.to.bodyMedium,
              textColor: color,
              highlightStyle: ThemeCont.to.bodyMedium?.copyWith(
                color: ThemeCont.to.point,
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
          iconColor: ThemeCont.to.point,
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
                textColor: ThemeCont.achro95,
                backgroundColor: ThemeCont.to.point,
                onPressed: cont.fetchButtonPressed,
              ),
            ],
          ),
        );
      }
      return FCard(title: title, child: child);
    });
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildCalendarCardWidget(context),
        SizedBox(height: 20.0.h),
        _buildDayRecordsWidget(context),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return FRefreshScaffold(
      refreshController: cont.refreshCont,
      onRefresh: calendarCont.init,
      height: PageCont.size.height * 1.2,
      appBar: FPointAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }
}