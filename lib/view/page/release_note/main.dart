import 'package:flutter/material.dart';

class ReleaseNotePage extends StatelessWidget {
  const ReleaseNotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('test')),
    );

    // final webViewController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {
    //         print(progress);
    //       // Update loading bar.
    //       },
    //       onPageStarted: (String url) {
    //         print(url);
    //       },
    //       onPageFinished: (String url) {
    //         print(url);
    //       },
    //       onWebResourceError: (WebResourceError error) {
    //         print(error);
    //       },
    //       onNavigationRequest: (NavigationRequest request) {
    //         print(request.url);
    //       if (request.url.startsWith(releaseNoteUrl)) {
    //         return NavigationDecision.prevent;
    //       }
    //       return NavigationDecision.navigate;
    //     },
    //   ),
    // )..loadRequest(Uri.parse(releaseNoteUrl));
    //
    // return Scaffold(
    //   body: SafeArea(
    //     child: WebViewWidget(
    //       controller: webViewController,
    //     ),
    //   ),
    // );
  }
}