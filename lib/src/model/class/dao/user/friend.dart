import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserFriendDAO extends DAO<FUserFriend> {
  static final FUserFriendDAO _instance = FUserFriendDAO._();
  FUserFriendDAO._();

  factory FUserFriendDAO() => _instance;

  @override
  String get collectionPath => 'userFriends';

  @override
  FUserFriend fromJson(Map<String, dynamic> json) {
    return FUserFriend.fromJson(json);
  }

  @override
  String get keyName => 'uid';
}