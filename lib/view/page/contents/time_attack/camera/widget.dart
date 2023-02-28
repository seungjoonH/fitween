import 'package:camera/camera.dart';
import 'package:fitween/presenter/page/contents/time_attack/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/presenter/widget/painter.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';

class CameraPainterView extends StatelessWidget {
  const CameraPainterView({
    Key? key,
    required this.painter,
  }) : super(key: key);

  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraP>(
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
    return GetBuilder<PainterP>(
        builder: (painterP) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FText(
                  '자세를 인식할게요',
                  style: textTheme.titleMedium,
                  color: FTheme.darkGrey,
                ),
                const SizedBox(height: 5.0),
                FText(
                  painterP.floatingMessage ?? '',
                  style: textTheme.headlineMedium,
                  color: FTheme.colorA,
                  bold: true,
                ),
              ],
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
        builder: (timeAttackCameraP) {
          return Positioned(
            bottom: 30.0.h,
            child: PButton(
              height: 80.h,
              stretch: true,
              constraints: BoxConstraints(maxWidth: 380.0.w),
              backgroundColor: FTheme.colorD,
              onPressed: timeAttackCameraP.finishWorkout,
              child: Text('${timeAttackCameraP.count} 개로 운동 완료하기',
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
    return GetBuilder<PainterP>(
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

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  State<CountDownTimer> createState() => CountDownTimerState();
}

class CountDownTimerState extends State<CountDownTimer> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PainterP>(
        builder: (painterP) {
          return FText(
            painterP.timeString,
            style: textTheme.displaySmall,
            color: FTheme.white,
            bold: true,
          );
        }
    );
  }
}