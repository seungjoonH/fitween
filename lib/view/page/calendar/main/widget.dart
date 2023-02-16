import 'package:fitween/view/page/calendar/main/utils.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/page/record/detail.dart';
import 'package:fitween/presenter/page/record/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class MyCalendarView extends StatelessWidget {
  const MyCalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordMain>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('오늘의 기록', style: textTheme.labelLarge),
            // Column(
            //   children: ActivityType.activeValues
            //       .map((type) => CalendarCard(type: type))
            //       .toList(),
            // ),
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
            //   width: 330.0,
            //   height: 110.0,
            //   child: Card(
            //     color: const Color(0xfffbf8f1),
            //     child: Row(
            //       children: [
            //         Container(
            //           width: 100.0,
            //           height: 100.0,
            //           padding: const EdgeInsets.all(5.0),
            //           decoration: const BoxDecoration(
            //             // color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10.0),
            //               bottomLeft: Radius.circular(10.0),
            //             ),
            //           ),
            //           child: SvgPicture.asset('assets/image/object/namhansanseong.svg'),
            //         ),
            //         Expanded(
            //           child: Container(
            //             padding: const EdgeInsets.all(10.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text('오늘 이동한 거리', style: TextStyle(fontSize: 12.0)),
            //                 const Text('남한산성', style: TextStyle(fontSize: 22.0)),
            //                 const Text('다음 단계 : 마라톤 풀코스 까지', style: TextStyle(fontSize: 12.0)),
            //                 Expanded(
            //                   child: LinearPercentIndicator(
            //                     percent: .9,
            //                     padding: EdgeInsets.zero,
            //                     lineHeight: 12.0,
            //                     barRadius: const Radius.circular(6.0),
            //                     progressColor: const Color(0xff54bab9),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
            //   width: 330.0,
            //   height: 110.0,
            //   child: Card(
            //     color: const Color(0xfffbf8f1),
            //     child: Row(
            //       children: [
            //         Container(
            //           width: 100.0,
            //           height: 100.0,
            //           padding: const EdgeInsets.all(5.0),
            //           decoration: const BoxDecoration(
            //             // color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10.0),
            //               bottomLeft: Radius.circular(10.0),
            //             ),
            //           ),
            //           child: SvgPicture.asset('assets/image/object/eiffel_tower.svg'),
            //         ),
            //         Expanded(
            //           child: Container(
            //             padding: const EdgeInsets.all(10.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text('오늘 오른 계단 높이', style: TextStyle(fontSize: 12.0)),
            //                 const Text('에펠탑', style: TextStyle(fontSize: 22.0)),
            //                 const Text('다음 단계 : 엠파이어 스테이트 빌딩 까지', style: TextStyle(fontSize: 12.0)),
            //                 Expanded(
            //                   child: LinearPercentIndicator(
            //                     percent: .2,
            //                     padding: EdgeInsets.zero,
            //                     lineHeight: 12.0,
            //                     barRadius: const Radius.circular(6.0),
            //                     progressColor: const Color(0xff54bab9),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
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
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
