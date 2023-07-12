import 'package:fitween/presenter/widget/loading.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewP extends GetxController {
  static WebViewController? webViewCont;

  static String fitweenUrl = 'https://fitween.notion.site/8bef341ef8904eed894c79b259903675?pvs=4';
  static String termUrl = 'https://fitween.notion.site/b32de8f7ca204fdc802d97a28b0e94d3?pvs=4';
  static String privacyPolicyUrl = 'https://fitween.notion.site/e98bf5c2840c4618ab0b778830373e1f?pvs=4';
  static String patchNoteUrl = 'https://fitween.notion.site/aa14492c494943ad803d15d30cb0b34b?pvs=4';
  static String supportUrl = 'https://fitween.notion.site/29ab2908321e4e499cb36814aac210cd?pvs=4';

  static init(String url) {
    final loadingP = Get.find<LoadingP>();

    webViewCont = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => loadingP.loadStart(),
          onPageFinished: (_) => loadingP.loadEnd(),
        ),
      )..loadRequest(Uri.parse(url));
  }

  static void _to(String title) {
    Get.toNamed('/seeMore/appInfo/webView', arguments: title);
  }

  static void toFitween() { _to('피트윈'); init(fitweenUrl); }
  static void toTerm() { _to('이용약관'); init(termUrl); }
  static void toPrivacyPolicy() { _to('개인정보처리방침'); init(privacyPolicyUrl); }
  static void toPatchNote() { _to('패치노트'); init(patchNoteUrl); }
  static void toSupport() { _to('고객지원'); init(supportUrl); }
}