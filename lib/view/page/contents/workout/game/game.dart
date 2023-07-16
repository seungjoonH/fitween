import 'package:camera/camera.dart';
import 'package:fitween/model/class/game/rocket_up.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/class/workout/inference.dart';
import 'package:fitween/model/class/workout/isolate.dart';
import 'package:fitween/model/enum/part.dart';
import 'package:fitween/presenter/page/contents/game/game.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/view/page/contents/workout/game/widget/game.dart';
import 'package:fitween/view/page/contents/workout/game/widget/gameover.dart';
import 'package:fitween/view/widget/painter/painter.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool doPredict = false;
  late Size inferenceSize;
  double widthRatio = 1.0;
  double heightRatio = 1.0;

  Map<Part, Inference>? inferences;
  late ExerciseHandler handler;

  late LimbPainter painter;
  int frameCount = 0;
  late Size screenSize;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  @override
  void dispose() {
    super.dispose();

    final cameraP = Get.find<CameraP>();
    GameP.init();
    cameraP.cameraController!.dispose();
  }

  void initAsync() async {
    final cameraP = Get.find<CameraP>();
    await cameraP.init();
    // await cameraP.cameraController!
    //     .startImageStream(createIsolate);
    ExerciseHandler.doWorkout();
    setState(() {});
  }

  void createIsolate(CameraImage imageStream) async {
    final gameP = Get.find<GameP>();

    if (doPredict) return;
    doPredict = true;

    IsolateData isolateData = IsolateData(
      cameraImage: imageStream,
      interpreterAddress: CameraP.classifier.interpreter.address,
      orientation: MediaQuery.of(context).orientation,
    );

    List inferenceList = await CameraP
        .isolate.inference(isolateData);

    inferenceSize = Size(
      imageStream.width.toDouble(),
      imageStream.height.toDouble(),
    );

    if (CameraP.canvasSize != null) {
      widthRatio = CameraP.canvasSize!.width / imageStream.width;
      heightRatio = CameraP.canvasSize!.height / imageStream.height;
    }

    inferences = {
      for (int i = 0; i < inferenceList.length; i++)
        Part.values[i] : Inference.list(inferenceList[i])
          ..adjustRatio(widthRatio, heightRatio)
    };

    Inference.saveHistory(inferences!);
    gameP.staging();

    if (!mounted) return;

    doPredict = false;
    ExerciseHandler.checkLimbs(Inference.refinedInferences);

    painter = LimbPainter(
      inferences: inferences!,
      limbs: ExerciseHandler.limbs,
      isSolo: true,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    bool isPortrait = orientation == Orientation.portrait;

    double ratio = screenSize.aspectRatio;
    ratio = ratio < 1 ? 1 / ratio : ratio;
    CameraP.canvasSize = screenSize;

    double cameraRatio = 16 / 9;
    if (isPortrait) cameraRatio = 1 / cameraRatio;

    double width = screenSize.width;
    double height = screenSize.height;

    bool isFat = ratio > cameraRatio;
    if (isPortrait) isFat = !isFat;

    if (isFat) { height = width / cameraRatio; }
    else { width = height * cameraRatio; }

    CameraP.canvasSize = Size(width, height);

    double horizontalError = .5 * (screenSize.width - CameraP.canvasSize!.width);
    double verticalError = .5 * (screenSize.height - CameraP.canvasSize!.height);

    // if (inferences == null) return const Scaffold();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: horizontalError, right: horizontalError,
            top: verticalError, bottom: verticalError,
            child: CustomPaint(
              // foregroundPainter: painter,
              child: GameWidget(
                game: RocketUp(),
                overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
                  'gameOverlay': (context, game) => GameOverlay(game),
                  'gameOverOverlay': (context, game) => GameOverOverlay(game),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
