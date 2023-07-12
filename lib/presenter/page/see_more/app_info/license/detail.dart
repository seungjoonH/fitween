import 'package:fitween/oss_licenses.dart';
import 'package:get/get.dart';

class LicenseDetailP extends GetxController {
  static void toLicenseDetail(Package package) {
    Get.toNamed('/seeMore/appInfo/license/detail', arguments: package);
  }
}