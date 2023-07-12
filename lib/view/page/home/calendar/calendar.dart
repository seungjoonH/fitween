import 'package:fitween/view/page/home/calendar/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(
        title: '기록',
        // actions: [
        //   GetBuilder<CalendarP>(
        //     builder: (calendarP) {
        //       return IconButton(
        //         icon: const Icon(Icons.refresh),
        //         onPressed: calendarP.fetchData,
        //       );
        //     }
        //   ),
        // ],
      ),
      body: MyCalendarView(),
    );
  }
}
