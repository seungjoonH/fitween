/* 설정 페이지 */

import 'package:fitween/view/page/my/setting/main/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

// 세팅 페이지
class MySettingMainPage extends StatelessWidget {
  const MySettingMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MySettingMainAppBar(),
      body: MySettingMainView(),
    );
  }
}
