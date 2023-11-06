import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportContentValidatorCont extends InputFieldValidatorCont {
  static ReportContentValidatorCont get to => Get.find<ReportContentValidatorCont>();

  final _controller = TextEditingController();

  @override
  TextEditingController get controller => _controller;

  ReportEditPageCont get editCont => ReportEditPageCont.to;

  @override
  String get emptyHintText {
    if (editCont.selectedType == ReportType.request) return ReportType.request.hintText!;
    return editCont.selectedBugType.guide;
  }

  @override
  String? validate() => text.isEmpty
      ? LangCont.tr('validate.empty.report-content')
      : null;

}