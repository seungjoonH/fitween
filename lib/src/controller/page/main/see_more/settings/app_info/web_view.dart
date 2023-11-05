import 'package:fitween/src/controller/controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class WebViewPageCont extends PageCont {
  String get appBarTitle;
  String get url;
  WebViewController get webViewCont => WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => LoadingCont.to.loadStart(),
        onPageFinished: (_) => LoadingCont.to.loadEnd(),
      ))
      ..loadRequest(Uri.parse(url));
}