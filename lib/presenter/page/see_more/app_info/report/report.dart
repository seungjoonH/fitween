import 'package:fitween/model/class/database/report.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/edit.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:get/get.dart';

class ReportP extends GetxController {
  List<Report> _reports = [];
  int? nextId;

  static void toReport() {
    Get.toNamed('/seeMore/appInfo/report');
    init();
  }

  static void init() async {
    final loadingP = Get.find<LoadingP>();
    final reportP = Get.find<ReportP>();

    loadingP.loadStart();

    await reportP.loadReport();

    loadingP.loadEnd();
  }

  List<Report> get reports => _reports;

  Future loadReport() async {
    final userP = Get.find<UserInfoP>();

    _reports = [];

    var collection = await f.collection('reports')
        .orderBy('id', descending: true).get();

    for (var json in collection.docs) {
      var data = json.data();
      Report report = Report.fromJson(data);
      nextId ??= report.id + 1;
      if (report.uid == userP.loggedUser.uid) _reports.add(report);
    }

    nextId ??= 1;

    update();
  }

  void saveReport(Report report) {
    var json = report.toJson();
    f.collection('reports').doc(report.docId).set(json);
  }

  void addReport(Report report) {
    _reports.add(report);
    saveReport(report);

    update();
  }

  void updateReport(Report report) {
    _reports.removeWhere((r) => r.id == report.id);
    _reports.add(report);
    _reports.sort((a, b) => b.id - a.id);
    saveReport(report);

    update();
  }

  Future deleteReport(Report report) async {
    _reports.removeWhere((r) => r.id == report.id);
    await f.collection('reports').doc(report.docId).delete();
  }

  void addButtonPressed(Report? report) => ReportEditP.toReportEdit(report);

  void deleteButtonPressed(Report report) async {
    bool deleteResponded = false;

    await showFDialog(
      title: '리포트 삭제',
      content: FText('정말 리포트를 삭제하시겠습니까?', maxLines: 2),
      type: DialogType.bi,
      leftPressed: Get.back,
      rightPressed: () {
        deleteResponded = true;
        Get.back();
      },
    );

    if (!deleteResponded) return;

    showFDialog(
      title: '리포트 삭제됨',
      content: FText('리포트가 삭제되었습니다.', maxLines: 2),
      type: DialogType.mono,
      onPressed: () async {
        await deleteReport(report);
        Get.back(); Get.back();
        update();
      },
    );

  }
}
