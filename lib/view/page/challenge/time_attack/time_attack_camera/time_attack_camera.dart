import 'package:camera/camera.dart';
import 'package:fitween/view/page/challenge/time_attack/time_attack_camera/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/isolate.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/model/enum/workout.dart';
import 'package:fitween/presenter/page/workout/main.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/presenter/widget/painter.dart';
import 'package:fitween/view/page/workout/main/widget.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/painter/painter.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../../../../presenter/page/challenge/time_attack/time_attack_camera.dart';

class TimeAttackCameraPage extends StatefulWidget {
  const TimeAttackCameraPage({Key? key}) : super(key: key);

  @override
  State<TimeAttackCameraPage> createState() => _TimeAttackCameraPageState();
}

class _TimeAttackCameraPageState extends State<TimeAttackCameraPage> {
  bool doPredict = false;
  late Size inferenceSize;
  double widthRatio = 1.0;
  double heightRatio = 1.0;

  Map<Part, Inference>? inferences;
  late ExerciseHandler handler;

  late LimbPainter painter;
  int frameCount = 0;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  @override
  void dispose() {
    super.dispose();

    final cameraP = Get.find<CameraPresenter>();
    final workoutMain = Get.find<TimeAttackCameraP>();
    workoutMain.init();
    cameraP.cameraController!.dispose();
  }

  void initAsync() async {
    final cameraP = Get.find<CameraPresenter>();
    await cameraP.init();
    await cameraP.cameraController!
        .startImageStream(createIsolate);
    handler = SquatHandler();
    handler.init();
    setState(() {});
  }

  void createIsolate(CameraImage imageStream) async {
    if (doPredict) return;
    doPredict = true;

    IsolateData isolateData = IsolateData(
      cameraImage: imageStream,
      interpreterAddress: CameraPresenter.classifier.interpreter.address,
    );

    List inferenceList = await CameraPresenter
        .isolate.inference(isolateData);

    inferences = {
      for (int i = 0; i < inferenceList.length; i++)
        Part.values[i] : Inference.list(inferenceList[i])
          ..adjustRatio(widthRatio, heightRatio)
    };

    Inference.saveHistory(inferences!);

    if (!mounted) return;

    switch (PainterPresenter.orientation) {
      case Orientation.portrait:
        inferenceSize = Size(
          imageStream.width.toDouble(),
          imageStream.height.toDouble(),
        );
        break;
      case Orientation.landscape:
        inferenceSize = Size(
          imageStream.height.toDouble(),
          imageStream.width.toDouble(),
        );
        break;
    }

    widthRatio = PainterPresenter.canvasSize.width / inferenceSize.width;
    heightRatio = PainterPresenter.canvasSize.height / inferenceSize.height;

    doPredict = false;
    handler.checkLimbs(Inference.refinedInferences);

    painter = LimbPainter(
      inferences: Inference.refinedInferences,
      limbs: handler.limbs,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (inferences == null) return const Scaffold();

    return GetBuilder<CameraPresenter>(
      builder: (cameraP) {
        return OrientationBuilder(
          builder: (context, orientation) {
            PainterPresenter.setOrientation(orientation);
            return Scaffold(
              extendBodyBehindAppBar: true,
              body: GetBuilder<PainterPresenter>(
                builder: (painterP) {
                  return Column(
                    children: [
                      const FloatingMessageWidget(),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: PainterPresenter.canvasSize.width,
                              height: PainterPresenter.canvasSize.height,
                              child: CameraPainterView(painter: painter),
                            ),
                            Positioned(
                              top: 60.0.h,
                                child: Image.asset('assets/image/challenge/timeAttack/frame.png')),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 60.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CountDownTimer(),
                                  // if (painterP.count > 0 && painterP.state == WorkoutState.stop)
                                  // const ExerciseCompleteButton(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (painterP.state == WorkoutState.workout)
                                      SizedBox(
                                        width: 100.0,
                                        child: PCircledButton(
                                          onPressed: painterP.workout,
                                          backgroundColor: FTheme.colorB,
                                          child: Image.asset('assets/image/challenge/timeAttack/button/pause.png'),
                                        ),
                                      ) else const SizedBox(width: 100.0),
                                      Container(
                                        width: 120, height: 92,
                                        decoration: BoxDecoration(
                                          color: FTheme.darkGrey,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: FText(
                                            '${painterP.count}',
                                            style: textTheme.displayLarge,
                                            color: FTheme.white,
                                            bold: true,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100.0,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Material(
                                              color: FTheme.grey,
                                              borderRadius: BorderRadius.circular(30.0),
                                              child: const SizedBox(
                                                width: 60.0,
                                                height: 60.0,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                cameraP.toggleDirection();
                                                initAsync();
                                              },
                                              icon: const Icon(
                                                Icons.cameraswitch_rounded,
                                                size: 33,
                                                color: FTheme.background,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (painterP.state != WorkoutState.workout)
                            PCircledButton(
                              onPressed: painterP.workout,
                              backgroundColor: FTheme.colorA,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Image.asset('assets/image/challenge/timeAttack/button/start.png'),
                              ),
                            ),
                            if (painterP.stateText != null)
                            const WorkoutStateWidget(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
