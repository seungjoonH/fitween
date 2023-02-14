import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/view/page/my/record/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';

class MyRecordMainPage extends StatelessWidget {
  const MyRecordMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments == null) return const Scaffold();
    ActivityType type = Get.arguments;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: FTheme.waterLight,
      appBar: const FAppBar(color: Colors.transparent),
      body: MyRecordDetailView(type: type),
    );
  }
}
