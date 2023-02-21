import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/page/edit_goal.dart';
import 'package:fitween/view/page/edit_goal/widget.dart';

class EditGoalPage extends StatefulWidget {
  const EditGoalPage({Key? key}) : super(key: key);

  @override
  State<EditGoalPage> createState() => _EditGoalPageState();
}

class _EditGoalPageState extends State<EditGoalPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: GetBuilder<EditGoalP>(
        builder: (editGoalP) {
          editGoalP.setKeyboardVisible(
            MediaQuery.of(context).viewInsets.bottom != 0,
          );
          return const Scaffold(
            body: CarouselView(),
          );
        },
      ),
    );
  }
}
