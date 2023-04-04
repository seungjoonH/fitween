import 'package:camera/camera.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/page/contents/workout/battle/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/widget/camera.dart';
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
  const FloatingMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BattleCameraP>(
      builder: (battleCameraP) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FText(
                  battleCameraP.message,
                  style: textTheme.headlineMedium,
                  color: FTheme.colorA,
                  maxLines: 2,
                  bold: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// class WorkoutStateWidget extends StatelessWidget {
//   const WorkoutStateWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<PainterP>(
//         builder: (painterP) {
//           return FText(
//             painterP.stateText!,
//             style: TextStyle(fontSize: 100.0.sp),
//             color: {
//               'HIT!': FTheme.colorA,
//               'GO!': FTheme.colorB,
//               'READY': FTheme.colorC,
//             }[painterP.stateText],
//           );
//         }
//     );
//   }
// }
//
class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BattleCameraP>(
      builder: (painterP) {
        Widget fText(String text) => Container(
          width: 50.0,
          alignment: Alignment.center,
          child: FText(text,
            style: textTheme.displaySmall,
            color: painterP.timerSeconds > 10
                ? FTheme.white : FTheme.error,
            bold: true,
          ),
        );

        return Container(
          width: 150.0,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color: painterP.timerSeconds > 10
                ? ActivityType.calorie.color
                : FTheme.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              fText(':'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  fText(painterP.minuteString),
                  fText(painterP.secondString),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}