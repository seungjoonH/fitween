import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/main/see_more/settings/app_info/web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PatchNotePage extends WebViewPage {
  const PatchNotePage({super.key});

  @override
  WebViewPageState createState() => _PatchNotePageState();
}

class _PatchNotePageState extends WebViewPageState {

  @override
  PatchNotePageCont get cont => PatchNotePageCont.to;

  @override
  String get appBarTitle => cont.appBarTitle;

  @override
  WebViewController get controller => cont.webViewCont;
}
