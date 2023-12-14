import 'package:fitween/global/global.dart';
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

  FUser get logged => AuthCont.logged!;

  Future init() async {
    logged.notification = await FUserNotificationDAO().loadOne(logged.key);
    await logged.notification!.loadAll();
    _notifications.assignAll(logged.notification!.data.reversed);
    _loaded(true);
  }

  Future remove(String id) async {
    _notifications.removeWhere((n) => n.key == id);
    logged.notification!.syncNotificationsFrom(notifications);
    await FUserNotificationDAO().saveOne(logged.notification!);
  }

  String get nextKey {
    if (notifications.isEmpty) return 0.zPad4;
    return (int.parse(notifications.last.key) + 1).zPad4;
  }
}