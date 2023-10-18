import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserPointDAO extends DAO<FUserPoint> {
  static final FUserPointDAO _instance = FUserPointDAO._();
  FUserPointDAO._();

  factory FUserPointDAO() => _instance;

  @override
  String get collectionPath => 'userPoints';

  @override
  FUserPoint fromJson(Map<String, dynamic> json) {
    return FUserPoint.fromJson(json);
  }

  @override
  String get keyName => 'uid';
}