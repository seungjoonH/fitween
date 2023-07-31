import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/page/contents/workout/ready.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BattleReadyView extends StatelessWidget {
  const BattleReadyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workoutReadyP = Get.find<WorkoutReadyP>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/image/page/contents/workout/focus.png',
                width: 250.0,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 50.0),
              FText(
                Lang.tr('btl.camera.pos-det'),
                style: textTheme(context).titleLarge,
                color: FTheme.darkGrey,
              ),
              const SizedBox(height: 10.0),
              FText(
                Lang.tr(
                  'btl.camera.pos-det-cmt',
                  args: [ExerciseHandler.workout.name],
                ),
                style: textTheme(context).bodySmall,
                color: FTheme.lightGrey,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50.0.h),
            child: FButton(
              text: Lang.tr('btn.start').capitalize,
              stretch: true,
              onPressed: workoutReadyP.startButtonPressed,
            ),
          )
        ],
      ),
    );
  }
}
