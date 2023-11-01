import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class NotificationCont extends GetxController {
  static NotificationCont get to => Get.find<NotificationCont>();

  final _notifications = <NotificationData>[].obs;
  List<NotificationData> get notifications => _notifications;
  int get uncheckedCount => notifications.where((n) => !n.checked).length;

  final _loaded = false.obs;
  bool get loaded => _loaded.value;

  FUser get _logged => AuthCont.logged!;

  Future init() async {
    _logged.notification = await FUserNotificationDAO().loadOne(_logged.key);
    await _logged.notification!.loadAll();
    _notifications.assignAll(_logged.notification!.data.reversed);
    _loaded(true);
  }
}