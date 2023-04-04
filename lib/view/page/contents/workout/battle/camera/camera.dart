import 'package:camera/camera.dart';
import 'package:fitween/presenter/page/contents/workout/battle/camera.dart';
import 'package:fitween/view/page/contents/workout/battle/camera/widget.dart';
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

class BattleCameraPage extends StatefulWidget {
  const BattleCameraPage({Key? key}) : super(key: key);

  @override
  State<BattleCameraPage> createState() => _BattleCameraPageState();
}

class _BattleCameraPageState extends State<BattleCameraPage> {
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
    BattleCameraP.init();
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
    final battleCameraP = Get.find<BattleCameraP>();

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
    battleCameraP.staging();

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
          body: GetBuilder<BattleCameraP>(
            builder: (battleCameraP) {
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
                        const Positioned(
                          top: 20.0,
                          child: TimerWidget(),
                        ),
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
                                      child: battleCameraP.state == WorkoutState.workout
                                          ? FCircledButton(
                                        onPressed: battleCameraP.stopButtonPressed,
                                        onLongPressed: battleCameraP.stopButtonLongPressed,
                                        backgroundColor: FTheme.colorB,
                                        child: const Icon(
                                          Icons.stop_rounded,
                                          color: FTheme.white,
                                          size: 50.0,
                                        ),
                                      ) : null,
                                    ),
                                    Container(
                                      width: 120, height: 80,
                                      decoration: BoxDecoration(
                                        color: FTheme.darkGrey,
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Center(
                                        child: FText(
                                          '${battleCameraP.count}',
                                          style: textTheme.displayLarge,
                                          color: FTheme.white,
                                          bold: true,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100.0,
                                      child: battleCameraP.state == WorkoutState.stop ? Stack(
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
                        AnimatedOpacity(
                          opacity: battleCameraP.activeSnackBar ? 1.0 : .0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: FTheme.grey,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: FText(
                              '중도포기를 하려면 버튼을 2초 이상 눌러주세요',
                              color: FTheme.white,
                              style: textTheme.titleSmall,
                            ),
                          ),
                        ),
                        if (battleCameraP.state == WorkoutState.stop)
                        FCircledButton(
                          onPressed: battleCameraP.startButtonPressed,
                          backgroundColor: FTheme.colorA,
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: FTheme.white,
                            size: 50.0,
                          ),
                        ),
                        if (battleCameraP.threeSecTimerState == TimerState.run)
                        FText(
                          '${battleCameraP.threeSecTimerSeconds}',
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
