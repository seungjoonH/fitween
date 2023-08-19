import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserCollectionDAO extends DAO<FUserCollection> {
  static final FUserCollectionDAO _instance = FUserCollectionDAO._();
  FUserCollectionDAO._();

  factory FUserCollectionDAO() => _instance;

  @override
  String get collectionPath => 'userCollections';

  @override
  FUserCollection fromJson(Map<String, dynamic> json) {
    return FUserCollection.fromJson(json);
  }

  @override
  String get keyName => 'uid';
}