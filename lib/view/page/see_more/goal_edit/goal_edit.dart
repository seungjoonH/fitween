import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/see_more/goal_edit/goal_edit.dart';
import 'package:fitween/view/page/see_more/goal_edit/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalEditPage extends StatefulWidget {
  const GoalEditPage({Key? key}) : super(key: key);

  @override
  State<GoalEditPage> createState() => _GoalEditPageState();
}

class _GoalEditPageState extends State<GoalEditPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: GetBuilder<GoalEditP>(
          builder: (goalEditP) {
            goalEditP.setKeyboardVisible(
              MediaQuery.of(context).viewInsets.bottom != 0,
            );
            return Scaffold(
              backgroundColor: FTheme.white,
              appBar: FAppBar(
                leading: IconButton(
                  onPressed: goalEditP.backPressed,
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
              ),
              body: const CarouselView(),
            );
          }
      ),
    );
  }
}
