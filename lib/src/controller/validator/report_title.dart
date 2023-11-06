import 'package:fitween/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportTitleValidatorCont extends InputFieldValidatorCont {
  static ReportTitleValidatorCont get to => Get.find<ReportTitleValidatorCont>();

  final _controller = TextEditingController();

  @override
  TextEditingController get controller => _controller;

  @override
  String get emptyHintText => LangCont.tr('hint.report-title');

  @override
  String? validate() => text.isEmpty
      ? LangCont.tr('validate.empty.report-title')
      : null;

}