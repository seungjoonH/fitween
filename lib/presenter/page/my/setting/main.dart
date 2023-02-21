import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/main.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/page/release_note.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';

/// class
class MySettingMain extends GetxController {
  /// static methods
  // 내 설정 메인 페이지로 이동
  static Future<bool> toMySettingMain() async {
    return await Get.toNamed('my/setting/main');
  }

  // 로그아웃 버튼 클릭 시
  static void logoutButtonPressed() => AuthPresenter.fLogout();

  // 계정 삭제 버튼 클릭 시
  static void accountDeleteButtonPressed() {
    showPDialog(
      type: DialogType.bi,
      title: '계정 삭제',
      titlePadding: const EdgeInsets.all(20.0),
      content: FText('정말 계정을 삭제하시겠습니까?'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      rightText: '삭제',
      leftPressed: Get.back,
      rightPressed: AuthPresenter.fDeleteAccount,
      rightBackgroundColor: Colors.red,
    );
  }

  static void showAppInfoDialog() {
    showPDialog(
      title: '앱 정보',
      content: Column(
        children: [
          FTextButton(
            text: '릴리즈 노트',
            style: textTheme.bodyLarge,
            onPressed: () {
              Get.back();
              ReleaseNoteMain.toReleaseNoteMain();
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
          ),
          FText(version, color: FTheme.darkGrey),
          const SizedBox(height: 20.0),
          FTextButton(
            text: '개발자 정보',
            style: textTheme.bodyLarge,
            onPressed: () {},
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
          ),
          FText('fitween.pistachio@gmail.com', color: FTheme.darkGrey),
        ],
      ),
      contentAlignment: CrossAxisAlignment.center,
    );
  }
}