import 'package:fitween/oss_licenses.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class LicenseDetailPageCont extends PageCont {
  static LicenseDetailPageCont get to => Get.find<LicenseDetailPageCont>();

  final _license = Rx<Package?>(null);

  Package? get license => _license.value;

  @override
  Future load() async {
    _license(Get.arguments as Package);
  }

  @override
  String get loadKey => 'license';

}