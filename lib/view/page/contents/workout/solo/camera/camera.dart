import 'package:camera/camera.dart';
import 'package:fitween/presenter/page/contents/workout/solo/camera.dart';
import 'package:fitween/view/page/contents/workout/solo/camera/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/isolate.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/model/enum/workout.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/presenter/widget/painter.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/painter/painter.dart';
import 'package:fitween/view/widget/widget/text.dart';

class WorkoutSoloCameraPage extends StatefulWidget {
  const WorkoutSoloCameraPage({Key? key}) : super(key: key);

  @override
  State<WorkoutSoloCameraPage> createState() => _WorkoutSoloCameraPage();
}

class _WorkoutSoloCameraPage extends State<WorkoutSoloCameraPage> {
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

    final cameraP = Get.find<CameraP>();
    WorkoutSoloCameraP.init();
    cameraP.cameraController!.dispose();
  }

  void initAsync() async {
    final cameraP = Get.find<CameraP>();
    await cameraP.init();
    await cameraP.cameraController!
        .startImageStream(createIsolate);
    ExerciseHandler.squat();
    setState(() {});
  }

  void createIsolate(CameraImage imageStream) async {
    final workoutSoloCameraP = Get.find<WorkoutSoloCameraP>();

    if (doPredict) return;
    doPredict = true;

    IsolateData isolateData = IsolateData(
      cameraImage: imageStream,
      interpreterAddress: CameraP.classifier.interpreter.address,
    );

    List inferenceList = await CameraP
        .isolate.inference(isolateData);

    inferences = {
      for (int i = 0; i < inferenceList.length; i++)
        Part.values[i] : Inference.list(inferenceList[i])
          ..adjustRatio(widthRatio, heightRatio)
    };

    Inference.saveHistory(inferences!);
    workoutSoloCameraP.staging();

    if (!mounted) return;

    inferenceSize = Size(
      imageStream.width.toDouble(),
      imageStream.height.toDouble(),
    );

    widthRatio = PainterP.canvasSize.width / inferenceSize.width;
    heightRatio = PainterP.canvasSize.height / inferenceSize.height;

    doPredict = false;
    ExerciseHandler.checkLimbs(Inference.refinedInferences);

    painter = LimbPainter(
      inferences: Inference.refinedInferences,
      limbs: ExerciseHandler.limbs,
      isSolo: true,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (inferences == null) return const Scaffold();

    return GetBuilder<CameraP>(
      builder: (cameraP) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: const FAppBar(),
          body: GetBuilder<WorkoutSoloCameraP>(
            builder: (workoutSoloCameraP) {
              bool showButton = [WorkoutState.workout, WorkoutState.ready]
                  .contains(workoutSoloCameraP.state);
              bool showStopButton = showButton && workoutSoloCameraP.count == 0;
              bool showPauseButton = showButton && workoutSoloCameraP.count > 0;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FloatingMessageWidget(),
                  SizedBox(
                    width: PainterP.canvasSize.width,
                    height: PainterP.canvasSize.height,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CameraPainterView(painter: painter),
                        // Positioned(
                        //   top: 60.0,
                        //   child: Image.asset('${assets}frame.png'),
                        // ),
                        Positioned(
                          bottom: 20.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 100.0,
                                      child: Stack(
                                        children: [
                                          if (showPauseButton)
                                          FCircledButton(
                                            onPressed: workoutSoloCameraP.pauseButtonPressed,
                                            backgroundColor: FTheme.colorD,
                                            child: const Icon(
                                              Icons.pause_rounded,
                                              color: FTheme.white,
                                              size: 50.0,
                                            ),
                                          ),
                                          if (showStopButton)
                                          FCircledButton(
                                            onPressed: workoutSoloCameraP.stopButtonPressed,
                                            backgroundColor: FTheme.colorB,
                                            child: const Icon(
                                              Icons.stop_rounded,
                                              color: FTheme.white,
                                              size: 50.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CountBoxWidget(
                                      count: workoutSoloCameraP.count,
                                      onPressed: workoutSoloCameraP.submitButtonPressed,
                                      pressable: workoutSoloCameraP.count > 0
                                          && workoutSoloCameraP.state == WorkoutState.pause,
                                    ),
                                    SizedBox(
                                      width: 100.0,
                                      child: workoutSoloCameraP.state == WorkoutState.stop ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Material(
                                            color: FTheme.lightGrey,
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
                                      ) : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if ([WorkoutState.pause, WorkoutState.stop].contains(workoutSoloCameraP.state))
                          FCircledButton(
                            onPressed: workoutSoloCameraP.startButtonPressed,
                            backgroundColor: FTheme.colorA,
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: FTheme.white,
                              size: 50.0,
                            ),
                          ),
                        if (workoutSoloCameraP.threeSecTimerState == TimerState.run)
                          FText(
                            '${workoutSoloCameraP.threeSecTimerSeconds}',
                            style: FTheme.veryLargeText,
                            color: FTheme.colorD,
                          ),
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
  }
}
