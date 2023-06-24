import 'package:fitween/global/theme.dart';
import 'package:get/get.dart';
import 'package:fitween/main.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';

class LoginP extends GetxController {
  static void showNetworkErrorDialog() {
    showFDialog(
      title: '네트워크 에러',
      content: FText(
        '네트워크가 연결되어 있지 않습니다.\nWifi 혹은 셀룰러 데이터를 연결한 후 앱을 이용해주세요.',
        style: FTheme.textTheme.bodyMedium,
        color: FTheme.error,
        maxLines: 3,
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  static void showVersionInvalidDialog() {
    showFDialog(
      title: '버전 미호환',
      content: FText(
        '$versionNumber 버전은 더 이상 지원하지 않습니다.\n최신버전으로 업데이트 해주세요.',
        maxLines: 2,
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  bool loading = false;
  double loadPercent = .0;

  void loadStart() { percent = .0; loading = true; update(); }
  void loadEnd() { percent = 1.0; loading = false; update(); }

  set percent(double p) { loadPercent = p; update(); }
}