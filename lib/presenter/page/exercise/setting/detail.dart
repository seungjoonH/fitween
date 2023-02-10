import 'package:get/get.dart';

/// class
// 운동 상세 설정 페이지
class ExerciseDetailSetting extends GetxController {
  int selectedIndex = 0;

  // 운동 선택
  void selectExercise(int index) { selectedIndex = index; update(); }
}