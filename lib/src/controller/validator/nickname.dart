import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/validator/validator.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum NewNicknameValidationType {
  isDuplicated, lessThanTwo,
  greaterThanEight, hasJamo, hasSpace,
  hasSpecialChar, onlyNumber, empty;

  String get hintText {
    const tr = 'validate';
    if (this == empty) return LangCont.tr('$tr.empty.your-nickname');
    return LangCont.tr('$tr.${name.toDashed}');
  }

  static NewNicknameValidationType? validate(String text) {
    NicknameValidatorCont cont = NicknameValidatorCont.to;
    int index = [
      cont.isDuplicated(text),
      cont.lessThanTwo(text),
      cont.greaterThanEight(text),
      cont.hasJamo(text),
      cont.hasSpace(text),
      cont.hasSpecialChar(text),
      cont.onlyNumber(text),
      cont.empty(text),
    ].lastIndexWhere((v) => v);

    return index < 0 ? null : values[index];
  }
}

class NicknameValidatorCont extends InputFieldValidatorCont {
  static NicknameValidatorCont get to => Get.find<NicknameValidatorCont>();

  final _controller = TextEditingController();

  @override
  String get emptyHintText => NewNicknameValidationType.empty.hintText;

  @override
  TextEditingController get controller => _controller;

  List<String> _nicknames = [];

  @override
  void onInit() {
    super.onInit();
    loadNicknames();
  }

  void loadNicknames() async {
    await FUserInfoDAO().loadAll(lightMode: true);
    _nicknames = FUserInfoDAO().list.values.map((user) => user.nickname).toList();
  }

  bool isDuplicated(String text) => _nicknames.contains(text);

  @override
  String? validate() {
    var type = NewNicknameValidationType.validate(text);
    return type?.hintText;
  }
}