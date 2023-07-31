import 'package:fitween/global/string.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/see_more/see_more.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Field {
  bool invalid = false;
  bool completed = false;
  String? hintText;
  dynamic controller;

  Field([this.controller]);
}

class InfoEditP extends GetxController {
  static Map<String, Field> fields = {
    'nickname': Field(TextEditingController()),
    'height': Field(TextEditingController()),
    'weight': Field(TextEditingController()),
  };

  static void backPressed() => SeeMoreP.toSeeMore();
  static void toInfoEdit() {
    init();
    Get.toNamed('/seeMore/infoEdit');
  }

  static void init() {
    final infoEditP = Get.find<InfoEditP>();
    infoEditP.loadAll();
  }

  late bool heightVisibility;
  late bool weightVisibility;


  void loadAll() {
    final userP = Get.find<UserInfoP>();
    fields['nickname']!.controller.text = userP.loggedUser.nickname!;
    fields['height']!.controller.text = '${userP.loggedUser.height!}';
    fields['weight']!.controller.text = '${userP.loggedUser.weight!}';

    fields['nickname']!.completed = false;
    fields['height']!.completed = false;
    fields['weight']!.completed = false;

    heightVisibility = userP.loggedUser.heightVisibility ?? true;
    weightVisibility = userP.loggedUser.weightVisibility ?? true;
    update();
  }

  void toggleHeightVisibility() {
    final userP = Get.find<UserInfoP>();
    heightVisibility = !heightVisibility;
    userP.loggedUser.heightVisibility = heightVisibility;
    update(); userP.save();
  }

  void toggleWeightVisibility() {
    final userP = Get.find<UserInfoP>();
    weightVisibility = !weightVisibility;
    userP.loggedUser.weightVisibility = weightVisibility;
    update(); userP.save();
  }

  Future<bool> nicknameValidate() async {
    final userP = Get.find<UserInfoP>();
    Field nicknameField = fields['nickname']!;
    String text = nicknameField.controller.text;

    String v(String text) => 'input.validate.$text';

    Map<String, bool> conditions = {
      '별명이 중복됩니다': await UserInfoP.duplicatedNickname(text),
      '현재와 같은 별명입니다': userP.loggedUser.nickname! == text,
      Lang.tr(v('less-two')): text.length < 2,
      Lang.tr(v('more-ten')): text.length > 10,
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
      nicknameField.controller.clear();
      nicknameField.invalid = true;
      nicknameField.completed = false;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        nicknameField.invalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        nicknameField.controller.text = text;
        nicknameField.hintText = null;
        update();
      });
      return true;
    }

    nicknameField.completed = true;
    nicknameField.controller.clear();
    nicknameField.hintText = '별명이 변경되었습니다';
    update();
    await Future.delayed(const Duration(milliseconds: 1000), () {
      nicknameField.controller.text = text;
      nicknameField.hintText = null;
      update();
    });

    return false;
  }

  bool heightInRange(String heightString) {
    if (int.tryParse(heightString) == null) return false;
    return FUserInfo.heightInRange(int.parse(heightString));
  }

  bool weightInRange(String weightString) {
    if (int.tryParse(weightString) == null) return false;
    return FUserInfo.weightInRange(int.parse(weightString));
  }

  Future<bool> heightValidate() async {
    final userP = Get.find<UserInfoP>();
    Field heightField = fields['height']!;
    String text = heightField.controller.text;

    Map<String, bool> conditions = {
      '현재와 같은 신장입니다': '${userP.loggedUser.height}' == text,
      '거짓말 치지 마세요': !heightInRange(text),
      '숫자만 입력해주세요': int.tryParse(text) == null,
      '신장을 입력해주세요': text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) heightField.hintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      heightField.controller.clear();
      heightField.invalid = true;
      heightField.completed = false;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        heightField.invalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        heightField.controller.text = text;
        heightField.hintText = null;
        update();
      });
      return true;
    }

    heightField.completed = true;
    heightField.controller.clear();
    heightField.hintText = '신장이 변경되었습니다';
    update();
    await Future.delayed(const Duration(milliseconds: 1000), () {
      heightField.controller.text = text;
      heightField.hintText = null;
      update();
    });

    return false;
  }

  Future<bool> weightValidate() async {
    final userP = Get.find<UserInfoP>();
    Field weightField = fields['weight']!;
    String text = weightField.controller.text;

    Map<String, bool> conditions = {
      '현재와 같은 체중입니다': '${userP.loggedUser.weight}' == text,
      '거짓말 치지 마세요': !weightInRange(text),
      '숫자만 입력해주세요': int.tryParse(text) == null,
      '체중을 입력해주세요': text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) weightField.hintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      weightField.controller.clear();
      weightField.invalid = true;
      weightField.completed = false;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        weightField.invalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        weightField.controller.text = text;
        weightField.hintText = null;
        update();
      });
      return true;
    }

    weightField.completed = true;
    weightField.controller.clear();
    weightField.hintText = '체중이 변경되었습니다';
    update();
    await Future.delayed(const Duration(milliseconds: 1000), () {
      weightField.controller.text = text;
      weightField.hintText = null;
      update();
    });

    return false;
  }

  void updateNickname() async {
    final userP = Get.find<UserInfoP>();
    if (await nicknameValidate()) return;
    userP.loggedUser.nickname = fields['nickname']!.controller.text;
    userP.save(); update();
  }

  void updateHeight() async {
    final userP = Get.find<UserInfoP>();
    if (await heightValidate()) return;
    userP.loggedUser.height = int.parse(fields['height']!.controller.text);
    userP.save(); update();
  }

  void updateWeight() async {
    final userP = Get.find<UserInfoP>();
    if (await weightValidate()) return;
    userP.loggedUser.weight = int.parse(fields['weight']!.controller.text);
    userP.save(); update();
  }

}