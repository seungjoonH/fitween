import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class NotificationCont extends GetxController {
  static NotificationCont get to => Get.find<NotificationCont>();

  List<NotificationData> get notifications => _logged.notification!.data;
  int get uncheckedCount => notifications.where((n) => !n.checked).length;

  final _loaded = false.obs;
  bool get loaded => _loaded.value;

  FUser get _logged => AuthCont.logged!;

  Future init() async {
    for (var data in notifications) { await data.load(); }
    _loaded(true);
  }
}