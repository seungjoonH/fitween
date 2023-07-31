import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:get/get.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/model/class/exercises.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/page/register.dart';

// 사용자의 체중
int get userWeight => Get.find<UserInfoP>().loggedUser.weight
    ?? Get.find<RegisterP>().newcomerInfo.weight ?? 0;

// 사용자의 신장
int get userHeight => Get.find<UserInfoP>().loggedUser.height
    ?? Get.find<RegisterP>().newcomerInfo.height ?? 0;

// 1분 간 소모 칼로리
Map<ActivityType, double> get calories => {
  ActivityType.distance: (
      Walking.calorie * .5 + Jogging.calorie * .3 + Running.calorie * .2
  ) / 15,
  ActivityType.height: StairClimbing.calorie / 15,
  ActivityType.weight: MuscularExercise.calorie / 15,
};

// 속력 (거리: 분/분, 높이: 층/분, 무게: 회/분)
Map<ActivityType, int> get velocities => {
  ActivityType.distance: 1,
  ActivityType.height: StairClimbing.velocity.ceil(),
  ActivityType.weight: MuscularExercise.velocity.ceil(),
};

// 활동별 소모 칼로리
// int convertToCalories(ActivityType type, int amount) {
//   double velocity = velocities[type]!.toDouble();
//   return (calories[type]! * velocity * amount).ceil();
// }

// 활동형식별 값 변환
// 거리: 분 > 보
// int convertRecord(ActivityType type, int amount) {
//   switch (type) {
//     case ActivityType.distance:
//       int converted = convertDistance(
//         amount, ExerciseUnit.minute, ExerciseUnit.step,
//       );
//       return converted;
//     case ActivityType.height: return amount;
//     default: return amount;
//   }
// }

// 무게 변환 (회 -> kg)
int convertWeight(int amount) => amount * userWeight;

String typeUnit(
  num amount, ActivityType type, {
  bool short = true,
  bool onlyUnit = false,
  bool isKg = false,
}) {
  String unit = Lang.plural('unit.wo-num.${type.name}', amount);
  String number = toLocalString(amount.toDouble());
  if (short) number = amount.toDouble().short!;
  if (isKg) unit = 'kg';
  if (onlyUnit) return unit;
  return '$number $unit';
}