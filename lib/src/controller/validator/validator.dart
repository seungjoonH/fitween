import 'package:fitween/global/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

export './nickname.dart';
export './date_of_birth.dart';
export './sex.dart';

abstract class ValidatorCont extends GetxController {
  final _shaking = false.obs;
  final _coloring = false.obs;

  bool get shaking => _shaking.value;
  bool get coloring => _coloring.value;

  set invalid(bool i) {
    if (i) { _shaking(i); _coloring(i); return; }
    _shaking(i);
    delay(500.ms, () => _coloring(i));
  }
  bool get invalid => shaking && coloring;

  void init();
  dynamic validate();
  void submit();
}

abstract class InputFieldValidatorCont extends ValidatorCont {
  TextEditingController get controller;
  final _text = ''.obs;

  final _hintText = RxnString();

  String get text => _text.value;
  String get emptyHintText;

  String? get hintText => _hintText.value ?? emptyHintText;
  Color get hintColor => _hintText.value == null ? FTheme.hintText : FTheme.error;

  bool lessThanTwo(String text) => text.length < 2;
  bool greaterThanEight(String text) => text.length > 8;
  bool notEight(String text) => text.length != 8;
  bool greaterThanHundred(String text) => text.length > 100;
  bool hasJamo(String text) => hasSeparatedConsonantOrVowel(text);
  bool hasSpace(String text) => text.contains(' ');
  bool hasSpecialChar(String text) => RegExp(r'[`~!@#$%^&*|"' r"'‘’””;:/?]").hasMatch(text);
  bool onlyNumber(String text) => int.tryParse(text) != null;
  bool hasNoNumber(String text) => !onlyNumber(text);
  bool empty(String text) => text == '';

  @override
  void init() => controller.clear();

  @override
  String? validate();

  @override
  void submit() async {
    _text(controller.text);
    _hintText(validate());
    invalid = _hintText.value != null;

    if (!invalid) return;
    controller.clear();

    await delay(500.ms, () => invalid = false);
    await delay(500.ms, () {
      controller.text = text;
      _hintText.value = null;
    });
  }
}

abstract class ButtonFieldValidatorCont<T> extends ValidatorCont {
  final Rxn<T> _t = Rxn<T>();

  T? get value => _t.value;
  void setValue(T v) => _t(v);

  @override
  void init() => _t.value = null;

  @override
  bool validate();

  @override
  void submit() async {
    invalid = validate();
    if (!invalid) return;

    await delay(500.ms, () => invalid = false);
  }
}