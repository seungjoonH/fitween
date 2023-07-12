import 'package:fitween/presenter/page/see_more/app_info/web_view.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = Get.arguments;
    bool isFitween = title == '피트윈';

    return Scaffold(
      appBar: isFitween
          ? const FAppBar()
          : FAppBar(title: title),
      body: SafeArea(
        child: FCircularProgressIndicator(
          child: WebViewWidget(controller: WebViewP.webViewCont!),
        ),
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: isFitween,
    );
  }
}
