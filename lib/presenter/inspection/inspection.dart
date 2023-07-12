import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/page/login.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:get/get.dart';

class Inspection {
  static DateTime? _startTime;
  static DateTime? _endTime;
  static String? _notice;

  static String? get start => dateToString('yyyy-MM-dd hh:mm', _startTime);
  static String? get end => dateToString('hh:mm', _endTime);

  static Future<bool> load() async {
    var collection = await f.collection('inspection').get();

    Duration? duration;

    bool inspecting = false;

    for (var doc in collection.docs.reversed) {
      var data = doc.data();
      _startTime = data['startTime'].toDate();
      duration = Duration(minutes: data['duration']);
      _notice = data['notice'];
      _endTime = _startTime!.add(duration);

      inspecting = _startTime!.isBefore(now) && _endTime!.isAfter(now);
      if (inspecting) { showInspectionDialog(); return true; }
    }

    return false;
  }

  static void showInspectionDialog() {
    showFDialog(
      title: '서비스 점검',
      content: FText(
        '점검내용:\n${_notice!}\n\n점검시간:\n$start ~ $end',
        style: textTheme(Get.context!).bodyLarge,
        maxLines: 5,
      ),
      type: DialogType.mono,
      onPressed: () {
        Get.back();
        LoginP.toLogin();
      },
    );
  }
}