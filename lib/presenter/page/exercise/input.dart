import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/home.dart';

class ExerciseInput extends GetxController {
  /// static variables

  /// static methods
  // 운동값 입력 페이지로 이동
  static void toExerciseInput(ActivityType type) async {
    final exerciseInput = Get.find<ExerciseInput>();

    exerciseInput.inputCont.clear();
    await GlobalPresenter.closeBottomBar();
    Get.toNamed('/exercise/input', arguments: type);
  }

  /// attributes

  /// methods
  final inputCont = TextEditingController();
  String? hintText;
  bool invalid = false;

  // 텍스트 입력 필드 값 유효 여부 반환
  Future<bool> validate(ActivityType type) async {
    PUser user = Get.find<UserPresenter>().loggedUser;
    String text = inputCont.text;

    Map<ActivityType, int> limit = {
      ActivityType.distance: 20000,
      ActivityType.height: 100,
    };

    Map<ActivityType, String> messages = {
      ActivityType.distance: '유산소 운동 시간',
      ActivityType.height: '오른 층 수',
    };

    Map<String, bool> conditions = {
      '하루 할당량을 초과하였습니다': (user.getTodayInputAmounts(type) + (stringToNum(text) ?? 0)) > limit[type]!,
      '너무 많이 입력했습니다': (stringToNum(text) ?? 0) > limit[type]!,
      '숫자만 입력할 수 있습니다': int.tryParse(text) == null,
      '공백을 포함할 수 없습니다': text.contains(' '),
      '${messages[type]}을 입력해주세요': text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) hintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      inputCont.clear();
      invalid = true; update();

      await Future.delayed(const Duration(milliseconds: 500), () {
        invalid = false; update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        inputCont.text = text; update();
        hintText = null;
      });
      return false;
    }
    return true;
  }

  // 완료 버튼 클릭 시
  Future completeButtonPressed(ActivityType type) async {
    final userP = Get.find<UserPresenter>();
    final homeP = Get.find<HomePresenter>();

    if (!await validate(type)) return;

    double amount = double.parse(inputCont.text);
    Record record = Record.init(type, amount, ExerciseUnit.minute);

    userP.addRecord(type, record);

    inputCont.clear();
    Get.back();
    homeP.init();
   }
}
