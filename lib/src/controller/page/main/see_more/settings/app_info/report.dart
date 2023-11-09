import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class ReportPageCont extends PageCont {
  static ReportPageCont get to => Get.find<ReportPageCont>();

  String get appBarTitle => LangCont.tr('appbar.report');

  final _reports = <Report>[].obs;
  List<Report> get reports => _reports;

  FUser get _logged => AuthCont.logged!;

  Future _loadMyReports() async {
    _reports.clear();
    var cols = await f.collection('reports')
        .where('uid', isEqualTo: _logged.key).get();

    for (var doc in cols.docs) {
      Map<String, dynamic> json = doc.data();
      _reports.add(Report.fromJson(json));
    }
  }

  void _sortReports() {
    int compareTo(Report a, Report b) => b.date.compareTo(a.date);
    _reports.sort(compareTo);
  }

  String get noReportsText => LangCont.tr('report.no-reports');

  int get lastIdOfReport {
    return maxOfList(reports.map((report) => report.id)).toInt();
  }

  void createReportButtonPressed() {
    FRoute.toReportEdit(report: Report(lastIdOfReport + 1));
  }

  void reportTilePressed(Report report) {
    FRoute.toReportDetail(report: report);
  }

  @override
  Future load() async {
    await _loadMyReports();
    _sortReports();
  }

  @override
  String get loadKey => 'report';
}