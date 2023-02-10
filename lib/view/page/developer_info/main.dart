import 'package:flutter/material.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/text.dart';

class DeveloperInfoPage extends StatelessWidget {
  const DeveloperInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBar(title: '개발자 정보'),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PText('문의: fitween.pistachio@gmail.com'),
          ],
        ),
      ),
    );
  }
}
