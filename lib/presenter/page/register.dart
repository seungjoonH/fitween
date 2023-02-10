import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/string.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/model/enum/sex.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/height.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/model/weight.dart';
import 'package:fitween/view/page/register/widget.dart';
import 'home.dart';

class Field {
  bool invalid = false;
  String? hintText;
  dynamic controller;

  Field([this.controller]);
}

/// class
class RegisterPresenter extends GetxController {
  int pageIndex = 0;
  bool invalid = false;
  List<bool> imageExistence = [false, false, false, true, true, true, true, true];
  bool imageVisualize = false;

  Map<String, Field> fields = {
    'nickname': Field(TextEditingController()),
    'dateOfBirth': Field(TextEditingController()),
    'sex': Field(),
  };

  static const Duration shakeDuration = Duration(milliseconds: 500);

  static Curve transitionCurve = Curves.easeInOut;
  static const Duration transitionDuration = Duration(milliseconds: 350);

  /// static variables
  static final carouselCont = CarouselController();

  static void toRegister() {
    final registerP = Get.find<RegisterPresenter>();
    registerP.init();
    Get.toNamed('/register');
  }

  /// static methods
  // 컨트롤러를 모두 초기화
  void init() {
    for (var field in fields.values) { field.controller?.clear(); }
    newcomer = PUser();
    pageIndex = 0;
  }

  // 현재 페이지 인덱스 증가
  void pageIndexIncrease() {
    if (pageIndex < CarouselView.widgetCount - 1) pageIndex++;
    update();
  }

  // 현재 페이지 인덱스 감소
  void pageIndexDecrease() {
    if (pageIndex > 0) pageIndex--;
    update();
  }

  /// attributes
  // 추가될 유저
  PUser newcomer = PUser();
  bool keyboardVisible = false;

  void setKeyboardVisible(bool value) {
    keyboardVisible = value;
    update();
  }

  /// methods
  // 성별 설정
  void setSex(Sex? value) {
    if (value == null) return;
    newcomer.sex = value;
    update();
  }

  // 체중 설정
  void setWeight(int value) {
    newcomer.weight = value;
    update();
  }

  // 신장 설정
  void setHeight(int value) {
    newcomer.height = value;
    update();
  }

  void initGoal(Record record) async {
    newcomer.goals[record.type!.name] = 0;
    update();
    await Future.delayed(const Duration(milliseconds: 500), () {
      newcomer.setGoal(record.type!, record);
      update();
    });
  }

  void submitted() async {
    final userP = Get.find<UserPresenter>();
    newcomer.nickname = fields['nickname']!.controller.text;
    newcomer.dateOfBirth = stringToDate(fields['dateOfBirth']!.controller.text);

    userP.login(newcomer);
    userP.loggedUser.regDate = now;

    await HomePresenter.toHome();
    await AuthPresenter.storeLoginData(userP.data);
    if (AuthPresenter.developerUids.contains(userP.loggedUser.uid)) {
      userP.awardBadge(BadgePresenter.getBadge('1999999')!, true);
    }
    userP.awardBadge(BadgePresenter.getBadge('1000000')!, true);

    init();
  }

  void nicknameValidate() async {
    Field nicknameField = fields['nickname']!;
    String text = nicknameField.controller.text;

    Map<String, bool> conditions = {
      '두 글자 이상 입력해주세요': text.length < 2,
      '열 글자 이하 입력해주세요': text.length > 10,
      '자음 모음은 단독으로 포함될 수 없습니다': hasSeparatedConsonantOrVowel(text),
      '공백을 포함할 수 없습니다': text.contains(' '),
      '특수문자는 포함할 수 없습니다': RegExp(r'[`~!@#$%^&*|"' r"'‘’””;:/?]").hasMatch(text),
      '영어나 한글을 포함해주세요': int.tryParse(text) != null,
      '별명을 입력해주세요': text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) nicknameField.hintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      invalid = true;
      nicknameField.controller.clear();
      nicknameField.invalid = true; update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        nicknameField.invalid = false; update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        nicknameField.controller.text = text; update();
        nicknameField.hintText = null;
      });
    }
  }

  void dateOfBirthValidate() async {
    Field dateOfBirthField = fields['dateOfBirth']!;
    String text = dateOfBirthField.controller.text;
    DateTime? date = stringToDate(text);

    Map<String, bool> conditions = {
      '잘못 입력하셨습니다': (today.year - (date?.year ?? 0)) > 99,
      '미래는 입력할 수 없습니다': today.isBefore(date ?? (today)),
      '오늘은 입력할 수 없습니다': isSameDay(today, date ?? today),
      '없는 날짜 입니다': date == null,
      '여덟 글자가 아닙니다': text.length != 8,
      '숫자만 입력해주세요': int.tryParse(text) == null,
      '생년월일을 입력해주세요': text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) dateOfBirthField.hintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      invalid = true;
      dateOfBirthField.controller.clear();
      dateOfBirthField.invalid = true; update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        dateOfBirthField.invalid = false; update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        dateOfBirthField.controller.text = text; update();
        dateOfBirthField.hintText = null;
      });
    }
  }

  void sexValidate() async {
    Field sexField = fields['sex']!;

    if (newcomer.sex == null) {
      invalid = true;
      sexField.invalid = true; update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        sexField.invalid = false; update();
      });
    }
  }

  void slideBack() async {
    imageVisualize = false;
    update();
    await Future.delayed(const Duration(milliseconds: 5), () {
      imageVisualize = imageExistence[pageIndex];
      update();
    });
  }

  void slideNext() async {
    imageVisualize = false;
    update();
    await Future.delayed(const Duration(milliseconds: 5), () {
      imageVisualize = imageExistence[pageIndex];
      update();
    });
  }

  // 다음 버튼 클릭 트리거
  void nextPressed() async {
    switch (pageIndex) {
      case 0:
        nicknameValidate();
        dateOfBirthValidate();
        sexValidate();
        if (invalid) { invalid = false; return; }
        newcomer.nickname = fields['nickname']!.controller.text;
        newcomer.dateOfBirth = stringToDate(fields['dateOfBirth']!.controller.text);
        newcomer.weight = WeightPresenter.getAverageWeight(newcomer.age, newcomer.sex!);
        newcomer.height = HeightPresenter.getAverageHeight(newcomer.age, newcomer.sex!);
        break;
      case 1: break;
      case 2: break;
      case 3:
        initGoal(Record.init(
          ActivityType.distance,
          60, ExerciseUnit.minute,
        ));
        break;
      case 4: break;
      case 5:
        initGoal(Record.init(ActivityType.height, 10));
        initGoal(Record.init(
          ActivityType.weight,
          100, ExerciseUnit.count,
        ));
        break;
      case 6:
        Record calorie = CalorieRecord(amount: 0);
        DistanceRecord distance = newcomer.getGoal(ActivityType.distance) as DistanceRecord;
        HeightRecord height = newcomer.getGoal(ActivityType.height) as HeightRecord;
        WeightRecord weight = newcomer.getGoal(ActivityType.weight) as WeightRecord;
        print(height.amount);
        calorie.amount += CalorieRecord.from(ActivityType.distance, distance.minute);
        print(CalorieRecord.from(ActivityType.distance, distance.minute));
        calorie.amount += CalorieRecord.from(ActivityType.height, height.amount);
        print(CalorieRecord.from(ActivityType.height, height.amount));
        calorie.amount += CalorieRecord.from(ActivityType.weight, weight.count);
        print(CalorieRecord.from(ActivityType.weight, weight.count));

        newcomer.setGoal(ActivityType.calorie, calorie);
        update();
        break;
      case 7:
        submitted(); return;
    }
    carouselCont.nextPage(
      curve: transitionCurve,
      duration: transitionDuration,
    );
    pageIndexIncrease();
    slideNext();
  }

  // 뒤로가기 버튼 클릭 트리거
  void backPressed() {
    if (pageIndex == 0) {
      final userP = Get.find<UserPresenter>();
      userP.logout();
      init();
      Get.offAllNamed('/login', arguments: true);
    }

    carouselCont.previousPage(
      curve: transitionCurve,
      duration: transitionDuration,
    );
    slideBack();
    pageIndexDecrease();
  }
}
