import 'package:fitween/view/page/calendar/main/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class CalendarMainPage extends StatelessWidget {
  const CalendarMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: PAppBar(title: '기록'),
      body: MyCalendarView(),
    );
  }
}
