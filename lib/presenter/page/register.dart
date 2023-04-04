import 'package:carousel_slider/carousel_controller.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/notification.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/class/database/user/battle.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/model/user/battle.dart';
import 'package:fitween/presenter/page/onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/string.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/model/enum/sex.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/height.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/weight.dart';
import 'package:fitween/view/page/register/widget.dart';
import 'home/home.dart';

class Field {
  bool invalid = false;
  String? hintText;
  dynamic controller;

  Field([this.controller]);
}

/// class
class RegisterP extends GetxController {
  int pageIndex = 0;
  bool invalid = false;
  List<bool> imageExistence = [
    false, false, false, true,
    false, true, true, true, false,
  ];
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
    init();
    Get.toNamed('/register');
  }

  static void init() {
    final registerP = Get.find<RegisterP>();
    registerP.loadAll();
  }

  Map<ActivityType, Record> amounts = {};

  void loadAll() {
    for (var field in fields.values) {
      field.controller?.clear();
    }
    newcomerCollection = FUserCollection();
    newcomerFriend = FUserFriend();
    newcomerInfo = FUserInfo();
    newcomerNotification = FUserNotification();
    newcomerParty = FUserParty();
    newcomerRecord = FUserRecord();
    newcomerBattle = FUserBattle();

    newcomerCollection.uid = AuthP.uid;
    newcomerFriend.uid = AuthP.uid;
    newcomerInfo.uid = AuthP.uid;
    newcomerNotification.uid = AuthP.uid;
    newcomerParty.uid = AuthP.uid;
    newcomerRecord.uid = AuthP.uid;
    newcomerBattle.uid = AuthP.uid;

    pageIndex = 0;

    for (ActivityType type in ActivityType.activeValues) {
      amounts[type] = Record.init(type, {
        ActivityType.distance: 60.0,
        ActivityType.height: 10.0,
        ActivityType.weight: 50.0,
      }[type]!, {
        ActivityType.distance: ExerciseUnit.minute,
        ActivityType.weight: ExerciseUnit.count,
      }[type]);
    }

    update();
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
  late FUserCollection newcomerCollection;
  late FUserFriend newcomerFriend;
  late FUserInfo newcomerInfo;
  late FUserNotification newcomerNotification;
  late FUserParty newcomerParty;
  late FUserRecord newcomerRecord;
  late FUserBattle newcomerBattle;
  bool keyboardVisible = false;

  void setKeyboardVisible(bool value) {
    keyboardVisible = value;
    update();
  }

  /// methods
  // 성별 설정
  void setSex(Sex? value) {
    if (value == null) return;
    newcomerInfo.sex = value;
    update();
  }

  // 체중 설정
  void setWeight(int value) {
    newcomerInfo.weight = value;
    update();
  }

  // 신장 설정
  void setHeight(int value) {
    newcomerInfo.height = value;
    update();
  }

  void initGoal(Record record) async {
    amounts[record.type!] = Record.init(record.type!, .0, {
      ActivityType.distance: ExerciseUnit.minute,
      ActivityType.weight: ExerciseUnit.count,
    }[record.type!]);
    update();
    await Future.delayed(const Duration(milliseconds: 500), () {
      amounts[record.type!] = record;
      update();
    });
  }

  void setGoal(Record record) {
    amounts[record.type!] = record;
  }

  void submitted() async {
    final userCollectionP = Get.find<UserCollectionP>();
    final userFriendP = Get.find<UserFriendP>();
    final userInfoP = Get.find<UserInfoP>();
    final userNotificationP = Get.find<UserNotificationP>();
    final userPartyP = Get.find<UserPartyP>();
    final userRecordP = Get.find<UserRecordP>();
    final userBattleP = Get.find<UserBattleP>();

    newcomerInfo.nickname = fields['nickname']!.controller.text;
    newcomerInfo.dateOfBirth = stringToDate(
      fields['dateOfBirth']!.controller.text,
    );

    for (ActivityType type in ActivityType.activeValues) {
      newcomerRecord.setGoal(type, today, amounts[type]!, {
        ActivityType.distance: ExerciseUnit.step,
        ActivityType.weight: ExerciseUnit.count,
      }[type]);
    }

    newcomerInfo.regDate = now;

    userCollectionP.login(newcomerCollection);
    userFriendP.login(newcomerFriend);
    userInfoP.login(newcomerInfo);
    userNotificationP.login(newcomerNotification);
    userPartyP.login(newcomerParty);
    userRecordP.login(newcomerRecord);
    userBattleP.login(newcomerBattle);

    HomeP.toHome();
    await AuthP.storeLoginData(userInfoP.data);
    if (AuthP.developerUids.contains(userInfoP.loggedUser.uid)) {
      userCollectionP.awardBadge(BadgeJsonP.getBadge('1999999')!, true);
    }
    userCollectionP.awardBadge(BadgeJsonP.getBadge('1000000')!, true);

    init();
  }

  Future nicknameValidate() async {
    Field nicknameField = fields['nickname']!;
    String text = nicknameField.controller.text;

    Map<String, bool> conditions = {
      '별명이 중복됩니다': await UserInfoP.duplicatedNickname(text),
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
      nicknameField.invalid = true;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        nicknameField.invalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        nicknameField.controller.text = text;
        update();
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
      '오늘은 입력할 수 없습니다': isSameDate(today, date ?? today),
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
      dateOfBirthField.invalid = true;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        dateOfBirthField.invalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        dateOfBirthField.controller.text = text;
        update();
        dateOfBirthField.hintText = null;
      });
    }
  }

  void sexValidate() async {
    Field sexField = fields['sex']!;

    if (newcomerInfo.sex == null) {
      invalid = true;
      sexField.invalid = true;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        sexField.invalid = false;
        update();
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
        await nicknameValidate();
        dateOfBirthValidate();
        sexValidate();
        if (invalid) {
          invalid = false;
          return;
        }
        newcomerInfo.nickname = fields['nickname']!.controller.text;
        newcomerInfo.dateOfBirth =
            stringToDate(fields['dateOfBirth']!.controller.text);
        newcomerInfo.weight = WeightPresenter.getAverageWeight(
            newcomerInfo.age, newcomerInfo.sex!);
        newcomerInfo.height = HeightPresenter.getAverageHeight(
            newcomerInfo.age, newcomerInfo.sex!);
        break;
      case 1: break;
      case 2: break;
      case 3:
        initGoal(Record.init(
          ActivityType.distance, 60,
          ExerciseUnit.minute,
        ));
        break;
      case 4: break;
      case 5:
        initGoal(Record.init(ActivityType.height, 10));
        break;
      case 6: break;
      case 7:
        initGoal(Record.init(
          ActivityType.weight, 50,
          ExerciseUnit.count,
        ));
        break;
      case 8:
        submitted();
        return;
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
      final userCollectionP = Get.find<UserCollectionP>();
      final userFriendP = Get.find<UserFriendP>();
      final userInfoP = Get.find<UserInfoP>();
      final userPartyP = Get.find<UserPartyP>();
      final userRecordP = Get.find<UserRecordP>();
      final userBattleP = Get.find<UserBattleP>();
      final onboardingP = Get.find<OnboardingP>();

      userCollectionP.logout();
      userFriendP.logout();
      userInfoP.logout();
      userPartyP.logout();
      userRecordP.logout();
      userBattleP.logout();

      init();

      onboardingP.init();
      Get.offAllNamed('/login');
      Get.toNamed('/onboarding', arguments: true);
    }

    carouselCont.previousPage(
      curve: transitionCurve,
      duration: transitionDuration,
    );

    slideBack();
    pageIndexDecrease();
  }
}
