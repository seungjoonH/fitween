import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class WebViewPage extends FPage {
  const WebViewPage({super.key});
}

abstract class WebViewPageState extends FPageState<WebViewPage> {
  String get appBarTitle;
  WebViewController get controller;

  bool get extendBodyBehindAppBar => false;

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      autoPadding: false,
      backgroundColor: ThemeCont.to.backgroundAlt,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: FAppBar(text: appBarTitle),
      body: FCircularProgressIndicator(
        child: WebViewWidget(controller: controller),
      ),
    );
  }

}