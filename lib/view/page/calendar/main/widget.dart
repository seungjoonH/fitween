import 'dart:math';

import 'package:fitween/view/page/calendar/main/utils.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/page/record/detail.dart';
import 'package:fitween/presenter/page/record/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordMain>(builder: (controller) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        width: 330.0,
        height: 110.0,
        child: Card(
          // color: const Color(0xfffbf8f1),
          child: InkWell(
            onTap: RecordDetail.toRecordDetail,
            borderRadius: BorderRadius.circular(10.0),
            child: Row(
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  child: SvgPicture.asset('assets/image/object/moai_stone.svg'),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FText(
                          '오늘 ${type.done} ${type.kr}',
                          style: textTheme.labelSmall,
                        ),
                        FText(
                          controller.tiers[type]!['current'].title,
                          style: textTheme.bodyLarge,
                        ),
                        FText(
                          '다음 단계 : ${controller.tiers[type]!['next'].title} 까지',
                          style: textTheme.labelSmall,
                        ),
                        Expanded(
                          child: LinearPercentIndicator(
                            percent: controller.tiers[type]!['percent'],
                            lineHeight: 12.0,
                            padding: EdgeInsets.zero,
                            barRadius: const Radius.circular(6.0),
                            progressColor: FTheme.primary[40],
                            animation: true,
                            animationDuration: 1000,
                            curve: Curves.easeInOut,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// MyCalendarView
class MyCalendarView extends StatefulWidget {
  const MyCalendarView({super.key});

  @override
  State<MyCalendarView> createState() => _MyCalendarViewState();
}

class _MyCalendarViewState extends State<MyCalendarView> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

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

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  Color colorSelector(Event event, int index) {
    if (event.clear) {
      return Colors.green;
    } else if (index == 0 && event.goal <= event.amount) {
      return Colors.red;
    } else if (index == 1 && event.goal <= event.amount) {
      return Colors.blue;
    } else if (index == 2 && event.goal <= event.amount) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  Widget percentView(List<Event> events, int index) {
    String unit = '';
    switch (index) {
      case 0:
        unit = '보';
        break;
      case 1:
        unit = '층';
        break;
      case 2:
        unit = '회';
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 110,
            lineHeight: 30.0,
            percent: min(events[index].amount / events[index].goal, 1),
            // center: Text('${events[index].amount / events[index].goal * 100}%'),
            barRadius: const Radius.circular(5),
            progressColor: colorSelector(events[index], index),
            trailing: IconButton(
              onPressed: () {
                setState(
                  () {
                    int temp = events[index].amount;
                    events[index].amount = events[index].goal;
                    events[index].goal = temp;
                    if (events[0].goal <= events[0].amount &&
                        events[1].goal <= events[1].amount &&
                        events[2].goal <= events[2].amount) {
                      events[0].clear = true;
                      events[1].clear = true;
                      events[2].clear = true;
                    } else {
                      events[0].clear = false;
                      events[1].clear = false;
                      events[2].clear = false;
                    }
                  },
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '${events[index].amount} / ${events[index].goal} $unit',
              style: TextStyle(
                color: colorSelector(events[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            child: TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekHeight: 20.0,
              calendarStyle: const CalendarStyle(
                cellMargin: EdgeInsets.all(2.0),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (BuildContext context, date, events) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: _getEventsForDay(date).first.clear
                            ? Colors.green
                            : Colors.black,
                      ),
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
                      return Container(
                        margin: const EdgeInsets.only(top: 28),
                        padding: const EdgeInsets.all(1),
                        child: Container(
                          width: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorSelector(events[index], index),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              locale: 'ko_Kr',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 0.0, 0.0),
                      child: Text(
                        DateFormat('MM' '월 ' 'dd' '일').format(_focusedDay),
                      ),
                    ),
                    percentView(value, 0),
                    percentView(value, 1),
                    percentView(value, 2),
                    const SizedBox(height: 12.0),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
