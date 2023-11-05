import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/app_info/support.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/app_info/web_view.dart';
import 'package:fitween/src/view/page/main/see_more/settings/app_info/web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SupportPage extends WebViewPage {
  const SupportPage({super.key});

  @override
  WebViewPageState createState() => _SupportPageState();
}

class _SupportPageState extends WebViewPageState {

  @override
  SupportPageCont get cont => SupportPageCont.to;

  @override
  String get appBarTitle => cont.appBarTitle;

  @override
  WebViewController get controller => cont.webViewCont;
}
