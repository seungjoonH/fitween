import 'dart:math';

import 'package:fitween/global/date.dart';
import 'package:fitween/presenter/page/calendar.dart';
import 'package:fitween/view/page/calendar/main/utils.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

// class CalendarCard extends StatelessWidget {
//   const CalendarCard({
//     Key? key,
//     required this.type,
//   }) : super(key: key);
//
//   final ActivityType type;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<RecordMain>(
//       builder: (controller) {
//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 15.0),
//           width: 330.0,
//           height: 110.0,
//           child: Card(
//             // color: const Color(0xfffbf8f1),
//             child: InkWell(
//               onTap: RecordDetail.toRecordDetail,
//               borderRadius: BorderRadius.circular(10.0),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 100.0,
//                     height: 100.0,
//                     padding: const EdgeInsets.all(5.0),
//                     decoration: const BoxDecoration(
//                       // color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10.0),
//                         bottomLeft: Radius.circular(10.0),
//                       ),
//                     ),
//                     child: SvgPicture.asset('assets/image/object/moai_stone.svg'),
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           FText(
//                             '오늘 ${type.done} ${type.kr}',
//                             style: textTheme.labelSmall,
//                           ),
//                           FText(
//                             controller.tiers[type]!['current'].title,
//                             style: textTheme.bodyLarge,
//                           ),
//                           FText(
//                             '다음 단계 : ${controller.tiers[type]!['next'].title} 까지',
//                             style: textTheme.labelSmall,
//                           ),
//                           Expanded(
//                             child: LinearPercentIndicator(
//                               percent: controller.tiers[type]!['percent'],
//                               lineHeight: 12.0,
//                               padding: EdgeInsets.zero,
//                               barRadius: const Radius.circular(6.0),
//                               progressColor: FTheme.primary[40],
//                               animation: true,
//                               animationDuration: 1000,
//                               curve: Curves.easeInOut,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

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
  // DateTime? _rangeStart;
  // DateTime? _rangeEnd;

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
    return calendarP.events[ignoreTime(day)] ?? [
      CalendarEvent(1, .0), CalendarEvent(1, .0), CalendarEvent(1, .0)
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDate(_selectedDay!, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FCard(
              child: TableCalendar<CalendarEvent>(
                firstDay: CalendarP.firstDay,
                lastDay: CalendarP.lastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                // rangeStartDay: calendarP.startDate,
                // rangeEndDay: calendarP.endDate,
                calendarFormat: CalendarFormat.month,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekHeight: 20.0,
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: true,
                  todayDecoration: BoxDecoration(
                    color: FTheme.grey,
                    shape: BoxShape.circle,
                  ),
                  cellMargin: EdgeInsets.all(2.0),
                  cellAlignment: Alignment.center,
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, events) {
                    // bool clear = false;
                    // clear &= _getEventsForDay(date).elementAt(0).amount >= _getEventsForDay(date).elementAt(0).goal;
                    // clear &= _getEventsForDay(date).elementAt(1).amount >= _getEventsForDay(date).elementAt(1).goal;
                    // clear &= _getEventsForDay(date).elementAt(2).amount >= _getEventsForDay(date).elementAt(2).goal;
                    return Container(
                      alignment: Alignment.center,
                      child: FText('${date.day}',
                        color: CalendarP.isAllFinished(_getEventsForDay(date))
                            ? ActivityType.calorie.color
                            : FTheme.black,
                        style: textTheme.bodyMedium,
                      ),
                    );
                  },
                  markerBuilder: (BuildContext context, date, events) {
                    if (events.isEmpty) return const SizedBox();
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        ActivityType type = ActivityType.activeValues[index];
                        return Container(
                          margin: const EdgeInsets.only(top: 28),
                          padding: const EdgeInsets.all(1),
                          child: Container(
                            width: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CalendarP.colorSelector(events, type),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                onDaySelected: _onDaySelected,
                // onRangeSelected: _onRangeSelected,
                onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  headerPadding: EdgeInsets.zero,
                  titleCentered: true,
                  titleTextStyle: textTheme.titleLarge!,
                ),
                locale: 'ko_Kr',
              ),
            ),
            const SizedBox(height: 20.0),
            FCard(
              child: ValueListenableBuilder<List<CalendarEvent>>(
                valueListenable: _selectedEvents,
                builder: (context, events, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FText(DateFormat('MM월 dd일').format(_focusedDay), style: textTheme.bodyLarge),
                      const SizedBox(height: 20.0),
                      Column(
                        children: ActivityType.activeValues.map((type) => TodayRecordLinearIndicator(
                          type: type, events: events,
                        )).toList(),
                      ),
                      const SizedBox(height: 12.0),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayRecordLinearIndicator extends StatefulWidget {
  const TodayRecordLinearIndicator({
    Key? key,
    required this.type,
    required this.events,
  }) : super(key: key);

  final ActivityType type;
  final List<CalendarEvent> events;

  @override
  State<TodayRecordLinearIndicator> createState() => _TodayRecordLinearIndicatorState();
}

class _TodayRecordLinearIndicatorState extends State<TodayRecordLinearIndicator> {
  @override
  Widget build(BuildContext context) {
    int amount = widget.events[widget.type.index - 1].amount.round();
    int goal = widget.events[widget.type.index - 1].goal.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: max(1, amount),
              child: Container(
                height: 36.0,
                decoration: BoxDecoration(
                  color: CalendarP.colorSelector(widget.events, widget.type, true),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: amount == 0 ? 49 : max(0, goal - amount),
              child: const SizedBox(),
            ),
          ],
        ),
        FText(
          '$amount / $goal ${widget.type.unit}',
          color: CalendarP.colorSelector(widget.events, widget.type, true),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
