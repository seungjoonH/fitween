import 'dart:async';

import 'package:fitween/global/date.dart' as date;
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class NotificationPageCont extends PageCont {
  static NotificationPageCont get to => Get.find<NotificationPageCont>();

  NotificationCont get notificationCont => NotificationCont.to;

  String get appBarTitle => LangCont.tr('appbar.notification');

  List<NotificationData> get notifications => notificationCont.notifications;

  void notificationPressed(NotificationData notification) async {
    notification.check();
    await notification.route();
    await FUserNotificationDAO().saveOne(_logged.notification!);
  }

  FUser get _logged => AuthCont.logged!;

  Timer? timer;
  final _now = date.now.obs;
  DateTime get now => _now.value;

  void startTimer() {
    timer = Timer.periodic(100.ms, (_) => _now(date.now));
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Future load() async {
    await notificationCont.init();
    startTimer();
  }

  @override
  String get loadKey => 'notification';
}