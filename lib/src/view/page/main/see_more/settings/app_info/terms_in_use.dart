import 'package:fitween/src/controller/page/main/see_more/settings/app_info/terms_in_use.dart';
import 'package:fitween/src/view/page/main/see_more/settings/app_info/web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsInUsePage extends WebViewPage {
  const TermsInUsePage({super.key});

  @override
  WebViewPageState createState() => _TermsInUsePageState();
}

class _TermsInUsePageState extends WebViewPageState {

  @override
  TermsInUsePageCont get cont => TermsInUsePageCont.to;

  @override
  String get appBarTitle => cont.appBarTitle;

  @override
  WebViewController get controller => cont.webViewCont;
}
