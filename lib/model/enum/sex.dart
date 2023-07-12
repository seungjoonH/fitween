// 성별 { 남성, 여성 }
import 'package:get/get.dart';

enum Sex {
  male, female;
  String get kr => ['남성', '여성'][index];

  // 문자열을 enum 으로 전환
  static Sex? toEnum(String? string) =>
  Sex.values.firstWhereOrNull((sex) => sex.name == string);
}
