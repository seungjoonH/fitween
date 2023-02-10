import 'package:get/get.dart';

class WorkoutGuide {
  static String asset = 'assets/image/page/workout';
  static String getAsset(int index) => '$asset/squat_$index.gif';
  static List<String> descriptions = [
    '화면과 같이 빨간색 네모 안에 위치해주세요!',
    '시작 버튼을 누르세요!',
    '바른 자세로\n원하는 만큼 스쿼트를 하세요!',
    '스쿼트를 그만하고 싶으면 종료 버튼 터치!\n무게 계산은 피스타치오가 알아서 해줄게요 :)',
  ];

  static void toWorkoutGuide() => Get.toNamed('/workout/guide');
}
