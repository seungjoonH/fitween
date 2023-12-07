import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/exercise.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class CameraPageCont extends PageCont {
  CameraCont get cameraCont => CameraCont.to;

  final _exercise = Rx<Exercise?>(null);
  Exercise? get exercise => _exercise.value;

  final _inferences = <Part, Inference>{}.obs;
  Map<Part, Inference> get inferences => _inferences;
  final _painter = Rx<LimbPainter?>(null);
  LimbPainter? get painter => _painter.value;

  void setPainter() {
    if (exercise == null) return;
    _painter.value = LimbPainter(
      handler: exercise!.handler,
      inferences: inferences,
    );
  }

  final _stage = ExerciseStage.stop.obs;
  ExerciseStage get stage => _stage.value;

  @override
  Future load() async {
    _exercise.value = Get.arguments as Exercise;
    setPainter();
  }

  void initAsync() async {
    _allowEstimate = true;
    await cameraCont.init();
    await cameraCont.cameraController!
        .startImageStream(createIsolate);
    syncMessage();
  }

  void disposeAll() => stop();

  bool _allowEstimate = true;

  void createIsolate(CameraImage imageStream) async {
    if (!_allowEstimate) return;
    _allowEstimate = false;

    IsolateData isolateData = IsolateData(
      cameraImage: imageStream,
      interpreterAddress: cameraCont.classifier.interpreter.address,
      orientation: PageCont.orientation,
    );

    List inferenceList = await cameraCont.isolate.inference(isolateData);

    if (inferenceList.isEmpty) {
      await cameraCont.disposeAll();
      await delay(100.ms, initAsync);
      return;
    }

    // Size inferenceSize = Size(
    //   imageStream.width.toDouble(),
    //   imageStream.height.toDouble(),
    // );

    Size size = PageCont.size;
    Size canvasSize = Size(
      size.width - 2 * cameraCont.left,
      size.height - 2 * cameraCont.top,
    );

    late double widthRatio;
    late double heightRatio;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        widthRatio = canvasSize.width / imageStream.height;
        heightRatio = canvasSize.height / imageStream.width;
        break;
      case TargetPlatform.iOS:
        widthRatio = canvasSize.width / imageStream.width;
        heightRatio = canvasSize.height / imageStream.height;
        break;
      default: break;
    }

    _inferences.assignAll({
      for (int i = 0; i < inferenceList.length; i++)
        Part.values[i] : Inference.list(inferenceList[i])
          ..adjustRatio(widthRatio, heightRatio)
    });

    _allowEstimate = true;

    if (exercise == null) return;

    exercise!.handler.checkLimbs(inferences);
    exercise!.handler.measureDistance(inferences);
    _estimating();

    setPainter();

  }

  final _count = 0.obs;
  int get count => _count.value;

  bool _restrictCount = false;

  void _countUp() async {
    if (!stage.isExercise) return;
    if (!isUnbendingMoment || !_wasPostureCorrect) return;
    if (_restrictCount) { _posture(ExercisePosture.fast); return; }
    _count(count + 1);
    _restrictCount = true;
    await delay(1500.ms, () => _restrictCount = false);
  }

  final _seconds = 3.obs;
  int get seconds => _seconds.value;

  final _humanDetectedQueue = <bool>[];
  static const _humanDetectedQueueMaxLength = 5;

  void _enqueueDetected() {
    _humanDetectedQueue.add(exercise!.handler.humanDetected);
    if (_humanDetectedQueue.length <= _humanDetectedQueueMaxLength) return;
    _dequeueDetected();
  }

  void _dequeueDetected() => _humanDetectedQueue.removeAt(0);

  bool get humanDetected => _humanDetectedQueue.every((hd) => hd);

  void _startTimerWhileDetectingHuman() {
    Timer.periodic(1.s, (timer) {
      _seconds(seconds - 1);
      bool isNotDetecting = !stage.isDetecting;
      if (isNotDetecting) {
        timer.cancel(); _seconds(3); return;
      }
      if (!humanDetected) {
        timer.cancel(); _seconds(3);
        _startTimerWhileDetectingHuman();
        return;
      }
      if (seconds == 0) {
        doExercise();
        timer.cancel(); _seconds(3); return;
      }
    });
  }

  void startButtonPressed() => start();
  void pauseButtonPressed() => pause();
  void stopButtonPressed() => stop();
  void countButtonPressed() => complete();
  void convertCameraButtonPressed() => convertCamera();

  void _setStage(ExerciseStage stage) { _stage(stage); syncMessage(); }

  final _bentQueue = <bool>[];
  static const int _bentQueueMaxLength = 5;

  void _enqueueBent() {
    if (exercise == null) return;
    _bentQueue.add(exercise!.handler.bent);
    if (_bentQueue.length <= _bentQueueMaxLength) return;
    _dequeueBent();
  }

  void _dequeueBent() => _bentQueue.removeAt(0);

  bool get bent => _bentQueue.every((b) => b);

  List<bool> get _subBentQueue => _bentQueue.sublist(0, _bentQueue.length - 1);
  bool get isBendingMoment => _subBentQueue.every((b) => !b) && _bentQueue.last;
  bool get isUnbendingMoment => _subBentQueue.every((b) => b) && !_bentQueue.last;

  final _postures = <ExercisePosture>[];

  void _addPosture() {
    if (exercise == null) return;
    if (!exercise!.handler.bent) { _postures.clear(); return; }
    _postures.add(exercise!.handler.posture);
  }

  static const int _postureMinCount = 5;
  bool get _wasPostureCorrect {
    if (_postures.length < _postureMinCount) return false;
    return _postures.every((p) => p == ExercisePosture.correct);
  }

  String get _bentMessage {
    String un = bent ? '' : 'un';
    return LangCont.tr('exercise.${un}bent.${exercise!.name}');
  }

  final _posture = ExercisePosture.unbent.obs;
  ExercisePosture get posture => _posture.value;

  void _setPostureMessage() async {
    if (isUnbendingMoment) {
      _posture(_wasPostureCorrect
          ? ExercisePosture.correct
          : ExercisePosture.wrong);

      await delay(2500.ms, () => _posture(ExercisePosture.unbent));
    }
  }

  final _humanDistance = HumanDistance.middle.obs;
  HumanDistance get humanDistance => _humanDistance.value;

  void _setHumanDistance() async {
    if (!stage.isDetecting && !stage.isExercise) return;
    _humanDistance(exercise!.handler.humanDistance);
  }

  void start() {
    if (stage.isStop) {
      _setStage(ExerciseStage.detecting);
      _startTimerOfMessageDotsCounting();
      _startTimerWhileDetectingHuman();
    }
    else if (stage.isPause) { doExercise(); }
  }

  void pause() {
    if (count == 0) { stop(); return; }
    _setStage(ExerciseStage.pause);
  }

  void stop() { _setStage(ExerciseStage.stop); _count(0); }
  void doExercise() => _setStage(ExerciseStage.exercise);
  void complete() {
    if (count == 0) return;
    _setStage(ExerciseStage.complete);
    FRoute.toWeightComplete(count: count);
  }

  void convertCamera() {
    cameraCont.convertCamera();
    initAsync();
  }

  void _estimating() {
    if (stage.isStop) return;
    _enqueueDetected();
    _enqueueBent();
    _setPostureMessage();
    _countUp();
    _addPosture();
    _setHumanDistance();
    if (!stage.isExercise) return;
    if (humanDistance != HumanDistance.middle) {
      addMessage(humanDistance.message);
      return;
    }
    addMessage('$_bentMessage\n${posture.message}');
  }

  final _message = ''.obs;
  String get message => _message.value;

  void syncMessage() => _message(stage.message);
  void addMessage(String m) => _message(stage.message + m);
  
  void _startTimerOfMessageDotsCounting() {
    if (!stage.isDetecting) return;
    int dotCount = 0;
    Timer.periodic(300.ms, (timer) {
      addMessage('.' * dotCount++);
      if (dotCount > 3) dotCount = 0;
      if (!stage.isDetecting) {
        syncMessage();
        timer.cancel(); return;
      }
    });
  }
}