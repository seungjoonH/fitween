import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/report.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/model/enum/report.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/detail.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/report.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReportEditP extends GetxController {
  final titleCont = TextEditingController();
  final contentCont = TextEditingController();

  bool titleInvalid = false;
  bool contentInvalid = false;

  String? titleHintText;
  String? contentHintText;

  Report? report;
  late bool isUpdate;

  static void toReportEdit([Report? report]) {
    final reportEditP = Get.find<ReportEditP>();
    reportEditP.init(report);
    Get.toNamed('/seeMore/appInfo/report/edit');
  }

  void init([Report? report]) {
    final reportP = Get.find<ReportP>();

    titleCont.clear();
    contentCont.clear();
    this.report = null;

    isUpdate = report != null;
    if (isUpdate) {
      if (report == null) return;
      titleCont.text = report.title!;
      contentCont.text = report.content!;
    }
    this.report = isUpdate ? report : Report(reportP.nextId!);
  }

  void typeChanged(ReportType? type) {
    report!.type = type!;
    update();
  }

  void isBugChanged(bool isBug) {
    report!.isBug = isBug;
    update();
  }

  Future<bool> titleValidate() async {
    String text = titleCont.text;

    Map<String, bool> conditions = {
      '10자 이내로 입력하세요.': text.length > 10,
      '리포트 제목을 입력하세요.': text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) titleHintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      titleCont.clear();
      titleInvalid = true;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        titleInvalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        titleCont.text = text;
        titleHintText = null;
        update();
      });
      return true;
    }

    return false;
  }

  Future<bool> contentValidate() async {
    String text = contentCont.text;

    Map<String, bool> conditions = {
      '100자 이내로 입력하세요.': text.length > 100,
      '리포트 내용을 입력하세요.': text == '',
    };

    conditions.forEach((message, condition) {
      if (condition) contentHintText = message;
    });

    if (conditions.values.any((condition) => condition)) {
      contentCont.clear();
      contentInvalid = true;
      update();
      await Future.delayed(const Duration(milliseconds: 500), () {
        contentInvalid = false;
        update();
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        contentCont.text = text;
        contentHintText = null;
        update();
      });
      return true;
    }

    return false;
  }

  void saveButtonPressed() async {
    if (await titleValidate()) return;
    if (await contentValidate()) return;

    showFDialog(
      title: '저장완료',
      content: FText('리포트가 저장되었습니다.'),
      type: DialogType.mono,
      onPressed: () async {
        Get.back();
        await _update();
        ReportDetailP.toReportDetail(report!);
      },
    );
  }

  Future _update() async {
    Get.back();
    report!.title = titleCont.text;
    report!.content = contentCont.text;
    report!.stage = ReportStage.saved;
    await save();
  }

  void submitButtonPressed() async {
    bool submitResponded = false;

    await showFDialog(
      title: '리포트 제출',
      content: FText(
        '정말 리포트를 제출하시겠습니까?\n제출 후에는 리포트 수정 및 삭제가 불가능합니다.',
        style: textTheme(Get.context!).bodyMedium,
        maxLines: 3,
      ),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightPressed: () {
        submitResponded = true;
        Get.back();
      },
    );

    if (!submitResponded) return;

    showFDialog(
      title: '리포트 제출됨',
      content: FText(
        '리포트가 제출되었습니다.\n소중한 의견 감사합니다.',
        maxLines: 2,
      ),
      type: DialogType.mono,
      onPressed: () async {
        Get.back();
        await _submit();
      },
    );
  }

  Future _submit() async {
    report!.stage = ReportStage.requested;
    await save();
  }

  Future save() async {
    final reportP = Get.find<ReportP>();
    (isUpdate ? reportP.addReport : reportP.updateReport)(report!);
    await reportP.loadReport();
  }
}