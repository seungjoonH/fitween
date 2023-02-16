import 'package:fitween/view/page/calendar/main/widget.dart';
import 'package:flutter/material.dart';
import '../../../widget/widget/app_bar.dart';

class CalendarMainPage extends StatelessWidget {
  const CalendarMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: FAppBar(title: '기록'),
      body: MyCalendarView(),
    );
  }
}
