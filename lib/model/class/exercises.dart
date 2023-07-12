/* 운동 모델 */
import 'package:fitween/global/unit.dart';

// 걷기
class Walking {
  // 운동계수
  static const double coefficient = .9;

  // 속력 (보/분)
  static const int velocity = 100;

  // 15분 소모 칼로리
  static int get calorie => (userWeight * coefficient).ceil();
}

// 조깅
class Jogging {
  // 운동계수
  static const double coefficient = 1.2;

  // 속력 (보/분)
  static const int velocity = 145;

  // 15분 소모 칼로리
  static int get calorie => (userWeight * coefficient).ceil();
}

// 달리기
class Running {
  // 운동계수
  static const double coefficient = 2.0;

  // 속력 (보/분)
  static const int velocity = 167;

  // 15분 소모 칼로리
  static int get calorie => (userWeight * coefficient).ceil();
}

// 계단오르기
class StairClimbing {
  // 운동계수
  static const double coefficient = 1.6;

  // 속력 (층/분)
  static const double velocity = 1;

  // 15분 소모 칼로리
  static int get calorie => (userWeight * coefficient).ceil();
}

// 근력운동
class MuscularExercise {
  // 운동계수
  static const double coefficient = 1.225;

  // 속력 (회/분)
  static const double velocity = 7;

  // 15분 소모 칼로리
  static int get calorie => (userWeight * coefficient).ceil();
}