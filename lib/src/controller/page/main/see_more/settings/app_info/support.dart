import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/app_info/web_view.dart';
import 'package:get/get.dart';

class SupportPageCont extends WebViewPageCont {
  static SupportPageCont get to => Get.find<SupportPageCont>();

  @override
  String get appBarTitle => LangCont.tr('appbar.support');

  @override
  String get url => 'https://fitween.notion.site/29ab2908321e4e499cb36814aac210cd?pvs=4';

  @override
  Future load() async {}

  @override
  String get loadKey => 'support';

}