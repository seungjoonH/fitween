import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/view/page/contents/achievement/level/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// class
class AchievementLevelPage extends StatelessWidget {
  const AchievementLevelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityType type = Get.arguments;

    return Scaffold(
      backgroundColor: FTheme.white,
      appBar: FAppBar(
        title: type.kr,
        textColor: FTheme.white,
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: Get.back,
        ),
      ),
      body: AchievementLevelView(type: type),
    );
  }
}