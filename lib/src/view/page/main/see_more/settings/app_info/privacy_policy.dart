import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/main/see_more/settings/app_info/web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends WebViewPage {
  const PrivacyPolicyPage({super.key});

  @override
  WebViewPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends WebViewPageState {

  @override
  PrivacyPolicyPageCont get cont => PrivacyPolicyPageCont.to;

  @override
  String get appBarTitle => cont.appBarTitle;

  @override
  WebViewController get controller => cont.webViewCont;
}
