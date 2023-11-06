import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:get/get.dart';

class ReportDetailPageCont extends PageCont {
  static ReportDetailPageCont get to => Get.find<ReportDetailPageCont>();

  ReportPageCont get reportCont => ReportPageCont.to;

  String get appBarTitle => '${LangCont.tr('appbar.report-detail')} #${report!.id}';

  final _report = Rx<Report?>(null);
  Report? get report => _report.value;

  String get developerAnswerText => LangCont.tr('report-detail.developer-answer');

  String get writerText => LangCont.tr('word.writer').capitalize!;
  String get dateText => LangCont.tr('word.write-date').capitalize!;
  String get categoryText => LangCont.tr('word.category').capitalize!;

  String get deleteButtonText => LangCont.tr('button.delete');

  String get _dialogTr => 'report-detail.dialog';
  String get reallyDeleteTitle => LangCont.tr('$_dialogTr.delete.really-title');
  String get reallyDeleteText => LangCont.tr('$_dialogTr.delete.really-text');
  String get deletedTitle => LangCont.tr('$_dialogTr.delete.complete-title');
  String get deletedText => LangCont.tr('$_dialogTr.delete.complete-text');

  void editButtonPressed() {
    FRoute.toReportEdit(report: report);
  }
  void deleteButtonPressed() {
    showFDialog(
      title: reallyDeleteTitle,
      content: FText(reallyDeleteText, maxLines: 0),
      type: DialogType.bi,
      rightText: deleteButtonText,
      rightBackgroundColor: ThemeCont.error,
      rightTextColor: ThemeCont.achro95,
      rightPressed: _deleteReport,
    );
  }

  void _deleteReport() async {
    await showFDialog(
      title: deletedTitle,
      content: FText(deletedText, maxLines: 0),
      type: DialogType.mono,
    );

    await f.collection('reports').doc(report!.docId).delete();
    await reportCont.onRefresh();
    Get.back();
  }

  @override
  Future load() async {
    _report.value = Get.arguments as Report;
  }

  @override
  String get loadKey => 'report-detail';

}