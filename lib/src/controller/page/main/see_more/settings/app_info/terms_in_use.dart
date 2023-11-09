import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/app_info/web_view.dart';
import 'package:get/get.dart';

class TermsInUsePageCont extends WebViewPageCont {
  static TermsInUsePageCont get to => Get.find<TermsInUsePageCont>();

  @override
  String get appBarTitle => LangCont.tr('appbar.terms-of-use');

  @override
  String get url => 'https://fitween.notion.site/b32de8f7ca204fdc802d97a28b0e94d3?pvs=4';

  @override
  Future load() async {}

  @override
  String get loadKey => 'terms-of-use';

}