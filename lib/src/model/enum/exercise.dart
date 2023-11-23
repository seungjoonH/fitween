import 'dart:ui';

import 'package:fitween/global/string.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/exercise.dart';
import 'package:fitween/src/model/class/exercise/handler.dart';
import 'package:fitween/src/model/enum/enum.dart';

enum Exercise {
  squat, shoulderPress;
  String get locale => LangCont.tr('exercise.${name.toSkewerCase}');
  static get asset => 'assets/image/page/contents/weight/';
  String get imageUrl =>'$asset$name/${ThemeCont.to.brightness.name}.gif';

  ExerciseHandler get handler {
    switch (this) {
      case Exercise.squat: return SquatHandler()..init();
      case Exercise.shoulderPress: return ShoulderPressHandler()..init();
    }
  }
}

enum ExerciseStage {
  stop, detecting, pause, exercise, complete;
  String get message => LangCont.tr('exercise.stage.$name');
  bool get showStart => [0, 2].contains(index);
  bool get showStop => [1, 2].contains(index);
  bool get showPause => index == 3;
  bool get showConvert => [0, 2].contains(index);
  Color get countButtonColor => [2, 4].contains(index)
      ? FType.weight.color
      : ThemeCont.achro20;
  bool get isStop => this == stop;
  bool get isDetecting => this == detecting;
  bool get isPause => this == pause;
  bool get isExercise => this == exercise;
  bool get isComplete => this == complete;
}

enum ExercisePosture {
  unbent, correct, wrong, fast;
  String get message => LangCont.tr('exercise.posture.$name');
  Paint get paint => [
    LimbPainter.pointBlue,
    LimbPainter.pointGreen,
    LimbPainter.pointRed,
    LimbPainter.pointRed,
  ][index];
}

enum HumanDistance {
  undetected, middle, near, far;
  String get message => LangCont.tr('exercise.human-distance.$name');
}