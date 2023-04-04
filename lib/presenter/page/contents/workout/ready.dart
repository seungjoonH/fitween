import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/model/user/battle.dart';
import 'package:fitween/presenter/page/contents/workout/battle/camera.dart';
import 'package:fitween/presenter/page/contents/workout/friend.dart';
import 'package:fitween/presenter/page/contents/workout/solo/camera.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkoutReadyP extends GetxController {
  static void toWorkoutReady() {
    Get.toNamed('/contents/workout/ready');
  }

  void startButtonPressed() {
    final workoutFriendP = Get.find<WorkoutFriendP>();
    if (workoutFriendP.selectedIndex == 0) {
      WorkoutSoloCameraP.toWorkoutSoloCamera(); return;
    }

    showFDialog(
      title: '타임어택 신청',
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FText('정말 '),
              FText(workoutFriendP.selectedRival.nickname!, bold: true),
              FText('님에게'),
            ],
          ),
          FText('도전 하시겠습니까?'),
          const SizedBox(height: 20.0),
          Column(
            children: [
              FText('기회: 2회', color: FTheme.lightGrey, style: textTheme.labelLarge),
              FText('운동시간: 3분', color: FTheme.lightGrey, style: textTheme.labelLarge),
              FText('기간: 24시간', color: FTheme.lightGrey, style: textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 20.0),
          FText(
            '주의! 시작하는 즉시 기회가 1회 소모됩니다.',
            color: FTheme.error,
            style: textTheme.labelLarge,
          ),
        ],
      ),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightPressed: () async {
        final userP = Get.find<UserBattleP>();
        Get.back();
        String id = await userP.applyBattle(workoutFriendP.selectedRival.uid!);
        BattleCameraP.toBattleCamera(id);
      },
    );
  }
}
