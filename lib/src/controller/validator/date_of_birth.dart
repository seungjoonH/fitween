import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/validator/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum DateOfBirthValidationType {
  wrongInput, isFuture, isToday,
  nonExistenceDate, notEight,
  hasNoNumber, empty;

  String get hintText {
    const tr = 'validate';
    if (this == empty) return LangCont.tr('$tr.empty.date-of-birth');
    return LangCont.tr('$tr.${name.toDashed}');
  }

  static DateOfBirthValidationType? validate(String text) {
    DateOfBirthValidatorCont cont = DateOfBirthValidatorCont.to;
    int index = [
      cont.wrongInput(text),
      cont.isFuture(text),
      cont.isToday(text),
      cont.nonExistenceDate(text),
      cont.notEight(text),
      cont.hasNoNumber(text),
      cont.empty(text),
    ].lastIndexWhere((v) => v);

    return index < 0 ? null : values[index];
  }
}

class DateOfBirthValidatorCont extends InputFieldValidatorCont {
  static DateOfBirthValidatorCont get to => Get.find<DateOfBirthValidatorCont>();

  final _controller = TextEditingController();

  @override
  String get emptyHintText => DateOfBirthValidationType.empty.hintText;

  @override
  TextEditingController get controller => _controller;

  bool wrongInput(String text) => (today.year - (stringToDate(text)?.year ?? 0)) > 99;
  bool isFuture(String text) => today.isBefore(stringToDate(text) ?? today);
  bool isToday(String text) => today.sameDay(stringToDate(text) ?? today);
  bool nonExistenceDate(String text) => stringToDate(text) == null;

  @override
  String? validate() {
    var type = DateOfBirthValidationType.validate(text);
    return type?.hintText;
  }
}