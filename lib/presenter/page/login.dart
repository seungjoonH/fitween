import 'package:get/get.dart';
import 'package:fitween/main.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';

class LoginPresenter {
  static void showVersionInvalidDialog() {
    showPDialog(
      title: '버전 미호환',
      content: FText(
        '$versionNumber 버전은 더 이상 지원하지 않습니다.\n최신버전으로 업데이트 해주세요.',
        maxLines: 2,
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }
}