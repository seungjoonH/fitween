import 'package:fitween/view/page/calendar/main/widget.dart';
import 'package:flutter/material.dart';
import '../../../widget/widget/app_bar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(title: '기록'),
      body: MyCalendarView(),
    );
  }
}
