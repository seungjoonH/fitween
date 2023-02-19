import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/string.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/presenter/model/user.dart';

/// class
class MySettingEdit extends GetxController {
  /// static variables
  static Map<String, String> kr = {
    'nickname': '별명',
    'height': '신장',
    'weight': '체중',
  };
  static final editConts = {
    'nickname': TextEditingController(),
    'height': TextEditingController(),
    'weight': TextEditingController(),
  };

  /// static methods
  // 내 설정 수정 페이지
  static void toMySettingEdit(String editType) {
    final userP = Get.find<UserInfoP>();
    FUserInfo user = userP.loggedUser;

    editConts['nickname']?.text = user.nickname!;
    editConts['height']?.text = '$userHeight';
    editConts['weight']?.text = '$userWeight';
    Get.toNamed('my/setting/edit', arguments: editType);
  }

  /// attributes
  bool invalid = false;
  String? hintText;


  /// methods
  // 입력 컨트롤러 초기화
  void clearConts() {
    for (var cont in editConts.values) { cont.clear(); }
  }

  Future<bool> validate(String editType) async {
    String text = editConts[editType]!.text;

    late Map<String, bool> conditions;

    switch (editType) {
      case 'nickname':
        conditions = {
          '두 글자 이상 입력해주세요': text.length < 2,
          '열 글자 이하 입력해주세요': text.length > 10,
          '자음 모음은 단독으로 포함될 수 없습니다': hasSeparatedConsonantOrVowel(text),
          '공백을 포함할 수 없습니다': text.contains(' '),
          '특수문자는 포함할 수 없습니다': RegExp(r'[`~!@#$%^&*|"' r"'‘’””;:/?]").hasMatch(text),
          '영어나 한글을 포함해주세요': int.tryParse(text) != null,
          '별명을 입력해주세요': text == '',
        }; break;
      default:
        conditions = {
          '숫자만 입력해주세요': int.tryParse(text) == null,
          '특수문자는 포함할 수 없습니다': RegExp(r'[`~!@#$%^&*|"' r"'‘’””;:/?]").hasMatch(text),
          '공백을 포함할 수 없습니다': text.contains(' '),
          '${withEulReul(kr[editType]!)} 입력해주세요': text == '',
        }; break;
    }

    conditions.forEach((message, condition) {
      if (condition) hintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      editConts[editType]!.clear();
      invalid = true; update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        invalid = false; update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        editConts[editType]!.text = text; update();
        hintText = null;
      });
      return false;
    }
    return true;
  }

  // 제출 시
  void submit(String editType) async {
    final userP = Get.find<UserInfoP>();
    FUserInfo user = userP.loggedUser;

    if (!await validate(editType)) return;

    user.nickname = editConts['nickname']!.text;
    user.height = int.parse(editConts['height']!.text);
    user.weight = int.parse(editConts['weight']!.text);

    userP.update();
    userP.save();
    Get.back();
  }


}