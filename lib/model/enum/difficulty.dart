import 'package:get/get.dart';

enum Difficulty {
  easy, normal, hard;
String get kr => ['쉬움', '보통', '어려움'][index];
bool get active => activeValues.contains(this);

// 문자열을 enum 으로 전환
static Difficulty? toEnum(String? string) =>
Difficulty.values.firstWhereOrNull((diff) => diff.name == string);

static List<Difficulty> get activeValues => [easy, normal, hard];
}
