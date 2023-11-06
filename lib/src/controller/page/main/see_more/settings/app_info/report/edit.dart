import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:get/get.dart';

class ReportEditPageCont extends PageCont {
  static ReportEditPageCont get to => Get.find<ReportEditPageCont>();

  String get appBarTitle => '${LangCont.tr('appbar.report-edit')} #${report!.id}';

  final _report = Rx<Report?>(null);
  Report? get report => _report.value;

  final _selectedType = ReportType.bugReport.obs;
  ReportType get selectedType => _selectedType.value;

  final _selectedBugType = BugReportType.qna.obs;
  BugReportType get selectedBugType => _selectedBugType.value;

  void selectType(ReportType type) {
    _selectedType(type);
    report!.setType(type);
  }

  void selectBugType(BugReportType? type) {
    if (type == null) return;
    _selectedBugType(type);
    report!.setBugType(type);
  }

  String get categoryText => LangCont.tr('word.category').capitalize!;

  String get _dialogTr => 'report.dialog';
  String get reportSaveTitle => LangCont.tr('$_dialogTr.save.title');
  String get reportSaveText => LangCont.tr('$_dialogTr.save.text');

  void saveButtonPressed() async {
    await showFDialog(
      title: reportSaveTitle,
      content: FText(reportSaveText, maxLines: 0),
      type: DialogType.mono,
    );

    report!.setStage(ReportStage.draft);
    await _saveReport();
  }

  String get submitButtonText => LangCont.tr('button.submit');

  String get reallySubmitTitle => LangCont.tr('$_dialogTr.submit.really-title');
  String get reallySubmitText => LangCont.tr('$_dialogTr.submit.really-text');
  String get submittedTitle => LangCont.tr('$_dialogTr.submit.complete-title');
  String get submittedText => LangCont.tr('$_dialogTr.submit.complete-text');

  ReportTitleValidatorCont titleCont = ReportTitleValidatorCont.to;
  ReportContentValidatorCont contentCont = ReportContentValidatorCont.to;

  void submitButtonPressed() async {
    titleCont.submit();
    contentCont.submit();

    if (titleCont.invalid || contentCont.invalid) return;

    showFDialog(
      title: reallySubmitTitle,
      content: FText(reallySubmitText, maxLines: 0),
      type: DialogType.bi,
      rightText: submitButtonText,
      rightPressed: submitReport,
    );
  }

  void submitReport() async {
    await showFDialog(
      title: submittedTitle,
      content: FText(submittedText, maxLines: 0),
      type: DialogType.mono,
    );

    report!.setStage(ReportStage.requested);
    await _saveReport();
    Get.back();
    FRoute.toReportDetail(report: report);
  }

  Future _saveReport() async {
    if (report == null) return;
    report!.setTitle(titleCont.text);
    report!.setContent(contentCont.text);

    var doc = f.collection('reports').doc(report!.docId);
    await doc.set(report!.toJson());

    await ReportPageCont.to.load();
  }

  @override
  Future load() async {
    _report.value = Get.arguments as Report;
    titleCont.setText(report?.title ?? '');
    contentCont.setText(report?.content ?? '');
  }

  @override
  String get loadKey => 'report-edit';

}