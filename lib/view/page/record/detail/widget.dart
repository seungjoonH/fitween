

import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ExerciseDetailView extends StatelessWidget{
  final double rate;
  final String measure;
  final String currentLevel;
  final String nextLevel;
  final String image;

  const ExerciseDetailView({
    Key? key,
    required this.rate,
    required this.measure,
    required this.currentLevel,
    required this.nextLevel,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percent = rate;
    if (rate == .0) percent = .05;

    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            width: 298,
            height: 242,
            child: SvgPicture.asset(image),
          ),
          const SizedBox(height: 10.0),
          Text(currentLevel,
            style: textTheme.headlineMedium,
          ),
          Container(
            padding: const EdgeInsets.only(top: 18),
            child: Text("다음 단계: $nextLevel 까지"),
          ),
          Container(
            width: 250.0,
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              //border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 10,
              backgroundColor: const Color(0xffD9D9D9),
              progressColor: const Color(0xff54BAB9).withOpacity(.3 + percent * 7 / 10),
              barRadius: const Radius.circular(10.0),
              percent: percent,
            ),
          ),
          SizedBox(
            width: 300.0,
            height: 250.0,
            child: SfCalendar(
              view: CalendarView.week,
              cellEndPadding: 0.0,
              firstDayOfWeek: 1,
              showCurrentTimeIndicator: false,
              viewNavigationMode: ViewNavigationMode.none,
              cellBorderColor: Colors.white,
              headerHeight: 0.0,
              todayHighlightColor: const Color(0xff54BAB9),
              selectionDecoration: BoxDecoration(
                border:
                Border.all(color: Colors.transparent),
              ),
              dataSource: MeetingDataSource(getAppointments()),
            ),
          )
        ],
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
  DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 3));

  meetings.add(
    Appointment(
      startTime: startTime,
      endTime: endTime,
      color: const Color(0xff54BAB9),
      isAllDay: false,
    ),
  );

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}