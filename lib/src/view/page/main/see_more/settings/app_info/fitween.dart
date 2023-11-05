import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/main/see_more/settings/app_info/web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FitweenPage extends WebViewPage {
  const FitweenPage({super.key});

  @override
  WebViewPageState createState() => _FitweenPageState();
}

class _FitweenPageState extends WebViewPageState {

  @override
  FitweenPageCont get cont => FitweenPageCont.to;

  @override
  String get appBarTitle => cont.appBarTitle;

  @override
  WebViewController get controller => cont.webViewCont;

  @override
  bool get extendBodyBehindAppBar => true;
}
