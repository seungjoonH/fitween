import 'package:fitween/oss_licenses.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/app_info/web_view.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OSSLicensesPageCont extends PageCont {
  static OSSLicensesPageCont get to => Get.find<OSSLicensesPageCont>();

  String get appBarTitle => LangCont.tr('appbar.oss-licenses');

  final _licenses = <Package>[].obs;
  List<Package> get licenses => _licenses;

  void _loadLicenses() {
    final ossKeys = ossLicenses.toList();
    int compare(Package a, Package b) => a.name.compareTo(b.name);
    _licenses.assignAll(ossKeys..sort(compare));
  }

  void listTilePressed(Package license) => FRoute.toLicenseDetail(license: license);

  @override
  Future load() async {
    _loadLicenses();
  }

  @override
  String get loadKey => 'oss-licenses';

}