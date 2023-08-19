import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserNotificationDAO extends DAO<FUserNotification> {
  static final FUserNotificationDAO _instance = FUserNotificationDAO._();
  FUserNotificationDAO._();

  factory FUserNotificationDAO() => _instance;

  @override
  String get collectionPath => 'userNotifications';

  @override
  FUserNotification fromJson(Map<String, dynamic> json) {
    return FUserNotification.fromJson(json);
  }

  @override
  String get keyName => 'uid';
}