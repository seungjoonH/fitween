import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/app_info/web_view.dart';
import 'package:get/get.dart';

class PatchNotePageCont extends WebViewPageCont {
  static PatchNotePageCont get to => Get.find<PatchNotePageCont>();

  @override
  String get appBarTitle => LangCont.tr('appbar.patch-note');

  @override
  String get url => 'https://fitween.notion.site/aa14492c494943ad803d15d30cb0b34b?pvs=4';

  @override
  Future load() async {}

  @override
  String get loadKey => 'patch-note';

}