import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/app_info/web_view.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPageCont extends WebViewPageCont {
  static PrivacyPolicyPageCont get to => Get.find<PrivacyPolicyPageCont>();

  @override
  String get appBarTitle => LangCont.tr('appbar.privacy-policy');

  @override
  String get url => 'https://fitween.notion.site/e98bf5c2840c4618ab0b778830373e1f?pvs=4';

  @override
  Future load() async {}

  @override
  String get loadKey => 'privacy-policy';

}