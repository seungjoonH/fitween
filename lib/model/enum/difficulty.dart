import 'package:get/get.dart';

enum Difficulty {
  easy, normal, hard;
String get kr => ['쉬움', '보통', '어려움'][index];
bool get active => activeValues.contains(this);

  static Difficulty? toEnum(String? string) =>
  Difficulty.values.firstWhereOrNull((diff) => diff.name == string);

  static List<Difficulty> get activeValues => [easy, normal, hard];
}
