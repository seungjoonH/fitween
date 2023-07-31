import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/view/page/home/calendar/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: Lang.tr('record').capitalize,
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
      body: const MyCalendarView(),
    );
  }
}
