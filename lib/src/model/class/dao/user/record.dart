import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserRecordDAO extends DAO<FUserRecord> {
  static final FUserRecordDAO _instance = FUserRecordDAO._();
  FUserRecordDAO._();

  factory FUserRecordDAO() => _instance;

  @override
  String get collectionPath => 'userRecords';

  @override
  FUserRecord fromJson(Map<String, dynamic> json) {
    return FUserRecord.fromJson(json);
  }

  @override
  String get keyName => 'uid';
}