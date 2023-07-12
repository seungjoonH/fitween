import 'dart:math';

import 'package:fitween/global/date.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/home/calendar.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendarView extends StatefulWidget {
  const MyCalendarView({super.key});

  @override
  State<MyCalendarView> createState() => _MyCalendarViewState();
}

class _MyCalendarViewState extends State<MyCalendarView> {
  final calendarP = Get.find<CalendarP>();
  late final ValueNotifier<List<CalendarEvent>> _selectedEvents;
  late RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  DateTime _focusedDay = now;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return calendarP.events?[ignoreTime(day)] ?? [
      CalendarEvent(1, .0), CalendarEvent(1, .0), CalendarEvent(1, .0)
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDate(_selectedDay!, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final refreshCont = RefreshController();

    return SmartRefresher(
      controller: refreshCont,
      onRefresh: () async {
        try {
          await CalendarP.init();
          refreshCont.refreshCompleted();
        } catch (e) {
          refreshCont.refreshFailed();
        }
      },
      onLoading: () async {
        await Future.delayed(const Duration(milliseconds: 100));
        refreshCont.loadComplete();
      },
      header: const MaterialClassicHeader(
        color: FTheme.black,
        backgroundColor: FTheme.surface,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.0.w,
            vertical: 28.0.h,
          ),
          child: Column(
            children: [
              FCard(
                constraints: BoxConstraints(minHeight: 370.0.h),
                child: TableCalendar<CalendarEvent>(
                  rowHeight: 52.0.h,
                  firstDay: CalendarP.firstDay,
                  lastDay: CalendarP.lastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.month,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  daysOfWeekHeight: 30.0.h,
                  pageJumpingEnabled: true,
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                      selectedDecoration: const BoxDecoration(
                      color: FTheme.darkGrey,
                      shape: BoxShape.circle,
                    ),
                      selectedTextStyle: textTheme(context).bodyLarge!.copyWith(
                      color: CalendarP.isAllFinished(_getEventsForDay(_selectedDay!))
                          ? ActivityType.calorie.color
                          : FTheme.white,
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: FTheme.darkGrey, width: 3.0.r),
                    ),
                    todayTextStyle: textTheme(context).bodyLarge!.copyWith(
                      color: CalendarP.isAllFinished(_getEventsForDay(today))
                          ? ActivityType.calorie.color
                          : FTheme.darkGrey,
                    ),
                    cellMargin: EdgeInsets.all(2.0.r),
                    cellAlignment: Alignment.center,
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, events) {
                      return Container(
                        alignment: Alignment.center,
                        child: FText('${date.day}',
                          color: CalendarP.isAllFinished(_getEventsForDay(date))
                              ? ActivityType.calorie.color
                              : FTheme.black,
                          style: textTheme(context).bodyMedium,
                        ),
                      );
                    },
                    markerBuilder: (context, date, events) {
                      final userP = Get.find<UserRecordP>();
                      date = ignoreTime(date)!;
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          ActivityType type = ActivityType.activeValues[index];
                          List<ActivityType> completed = userP.loggedUser.completedActivities(date);
                          int amount = userP.loggedUser.getAmounts(type, date, nextDay(date)).round();

                          Color color = FTheme.lightGrey;
                          if (completed.length == 3) { color = ActivityType.calorie.color; }
                          else if (completed.contains(type)) { color = type.color; }
                          else if (amount == 0 || date.isAfter(now)) { color = Colors.transparent; }

                          return Container(
                            margin: EdgeInsets.only(top: 30.0.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 1.0.w,
                              vertical: 1.0.h,
                            ),
                            child: Container(
                              width: 8.0.r, height: 8.0.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  onDaySelected: _onDaySelected,
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    headerPadding: EdgeInsets.zero,
                    titleCentered: true,
                    titleTextStyle: textTheme(context).titleLarge!,
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: FTheme.black,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: FTheme.black,
                    ),
                  ),
                  locale: 'ko_Kr',
                ),
              ),
              SizedBox(height: 20.0.h),
              FCard(
                constraints: BoxConstraints(minHeight: 280.0.h),
                child: ValueListenableBuilder<List<CalendarEvent>>(
                  valueListenable: _selectedEvents,
                  builder: (context, events, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FText(DateFormat('MM월 dd일').format(_focusedDay), style: textTheme(context).bodyLarge),
                        SizedBox(height: 20.0.h),
                        Column(
                          children: ActivityType.activeValues.map((type) => TodayRecordLinearIndicator(
                            type: type, date: ignoreTime(_focusedDay)!,
                          )).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodayRecordLinearIndicator extends StatefulWidget {
  const TodayRecordLinearIndicator({
    Key? key,
    required this.type,
    required this.date,
  }) : super(key: key);

  final ActivityType type;
  final DateTime date;

  @override
  State<TodayRecordLinearIndicator> createState() => _TodayRecordLinearIndicatorState();
}

class _TodayRecordLinearIndicatorState extends State<TodayRecordLinearIndicator> {
  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserRecordP>();

    int amount = userP.loggedUser.getAmounts(
      widget.type, widget.date,
      nextDay(widget.date),
    ).round();
    int goal = userP.loggedUser.getGoal(widget.type, widget.date)?.amount.round() ?? 1;
    Color color = FTheme.lightGrey;

    List<ActivityType> completed = userP.loggedUser.completedActivities(widget.date);

    if (completed.length == 3) { color = ActivityType.calorie.color; }
    else if (completed.contains(widget.type)) { color = widget.type.color; }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearPercentIndicator(
          percent: max(min(amount / goal, 1.0), .02),
          backgroundColor: Colors.transparent,
          fillColor: Colors.transparent,
          progressColor: color,
          lineHeight: 36.0.h,
          padding: EdgeInsets.zero,
          barRadius: Radius.circular(5.0.r),
          animation: true,
          curve: Curves.easeInOut,
          animateFromLastPercent: true,
          animationDuration: 800,
        ),
        FText(
          '$amount / $goal ${widget.type.unit}',
          color: color,
          style: textTheme(context).bodyMedium,
        ),
        SizedBox(height: 10.0.h),
      ],
    );
  }
}
