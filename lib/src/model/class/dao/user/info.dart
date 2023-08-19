import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserInfoDAO extends DAO<FUserInfo> {
  static final FUserInfoDAO _instance = FUserInfoDAO._();
  FUserInfoDAO._();

  factory FUserInfoDAO() => _instance;

  @override
  String get collectionPath => 'userInfos';

  @override
  FUserInfo fromJson(Map<String, dynamic> json) {
    return FUserInfo.fromJson(json);
  }

  @override
  String get keyName => 'uid';
}