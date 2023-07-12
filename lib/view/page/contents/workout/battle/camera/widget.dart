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
    Size screenSize = MediaQuery.of(context).size;
    CameraP.canvasSize = screenSize;
    Orientation orientation = MediaQuery.of(context).orientation;

    switch (orientation) {
      case Orientation.portrait:
        CameraP.canvasSize = Size(screenSize.width, screenSize.width * 16 / 9); break;
      case Orientation.landscape:
        CameraP.canvasSize = Size(screenSize.height * 16 / 9, screenSize.height); break;
    }

    double horizontalError = .5 * (screenSize.width - CameraP.canvasSize!.width);
    double verticalError = .5 * (screenSize.height - CameraP.canvasSize!.height);

    return GetBuilder<CameraP>(
      builder: (cameraP) {
        return Stack(
          children: [
            Positioned(
              left: horizontalError, right: horizontalError,
              top: verticalError, bottom: verticalError,
              child: GestureDetector(
                onScaleStart: (details) => cameraP.setInitZoom(),
                onScaleUpdate: cameraP.setZoomLevel,
                child: CustomPaint(
                  foregroundPainter: painter,
                  child: CameraPreview(
                    cameraP.cameraController!,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FloatingMessageWidget extends StatelessWidget {
  const FloatingMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    EdgeInsets padding = EdgeInsets.all(screenSize.width * .05);

    return GetBuilder<BattleCameraP>(
      builder: (battleCameraP) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * .05,
            vertical: 40.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: padding,
                decoration: BoxDecoration(
                  color: FTheme.black.withOpacity(.4),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: FText(
                  battleCameraP.message,
                  style: CameraP.orientation == Orientation.portrait
                      ? textTheme(context).headlineMedium : textTheme(context).headlineLarge,
                  color: FTheme.colorA,
                  maxLines: 2,
                  bold: true,
                ),
              ),
            ],
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
            style: textTheme(context).displaySmall,
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