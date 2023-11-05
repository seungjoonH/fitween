import 'package:fitween/src/controller/page/main/see_more/settings/app_info/web_view.dart';
import 'package:get/get.dart';

class FitweenPageCont extends WebViewPageCont {
  static FitweenPageCont get to => Get.find<FitweenPageCont>();

  @override
  String get appBarTitle => '';

  @override
  Future load() async {}

  @override
  String get url => 'https://fitween.notion.site/Fitween-8bef341ef8904eed894c79b259903675?pvs=4';

  @override
  String get loadKey => 'fitween';

}