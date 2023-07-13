import 'package:fitween/model/class/database/report.dart';
import 'package:get/get.dart';

class ReportDetailP extends GetxController {
  static void toReportDetail(Report report) {
    Get.toNamed('/seeMore/appInfo/report/detail', arguments: report);
  }
}