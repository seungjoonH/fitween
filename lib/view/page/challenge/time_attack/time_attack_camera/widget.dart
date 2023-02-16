import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/workout/main.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/presenter/widget/painter.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';

import '../../../../../presenter/page/challenge/time_attack/time_attack_camera.dart';

class CameraPainterView extends StatelessWidget {
  const CameraPainterView({
    Key? key,
    required this.painter,
  }) : super(key: key);

  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraPresenter>(
        builder: (cameraP) {
          return GestureDetector(
            onScaleStart: (details) => cameraP.setInitZoom(),
            onScaleUpdate: cameraP.setZoomLevel,
            child: CustomPaint(
              foregroundPainter: painter,
              child: CameraPreview(
                cameraP.cameraController!,
              ),
            ),
          );
        }
    );
  }
}


class FloatingMessageWidget extends StatelessWidget {
  const FloatingMessageWidget({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PainterPresenter>(
        builder: (painterP) {
          return Positioned(
            bottom: 30.0.h,
            child: Container(
              alignment: Alignment.center,
              width: PainterPresenter.canvasSize.width * .8,
              height: 70.0.h,
              constraints: const BoxConstraints(maxWidth: 340.0),
              decoration: BoxDecoration(
                color: FTheme.white.withOpacity(.6),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: FText(
                painterP.floatingMessage!,
                style: textTheme.headlineSmall,
              ),
            ),
          );
        }
    );
  }
}

class ExerciseCompleteButton extends StatelessWidget {
  const ExerciseCompleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimeAttackCameraP>(
        builder: (workoutMain) {
          return Positioned(
            bottom: 30.0.h,
            child: PButton(
              height: 80.h,
              stretch: true,
              constraints: BoxConstraints(maxWidth: 300.0.w),
              backgroundColor: FTheme.colorD,
              onPressed: workoutMain.finishWorkout,
              child: Text('${workoutMain.count} 개로 운동 완료하기',
                style: textTheme.headlineSmall,
              ),
            ),
          );
        }
    );
  }
}

class WorkoutStateWidget extends StatelessWidget {
  const WorkoutStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PainterPresenter>(
        builder: (painterP) {
          return FText(
            painterP.stateText!,
            style: TextStyle(fontSize: 100.0.sp),
            color: {
              'HIT!': FTheme.colorA,
              'GO!': FTheme.colorB,
              'READY': FTheme.colorC,
            }[painterP.stateText],
          );
        }
    );
  }
}
