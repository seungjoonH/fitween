import 'package:fitween/global/firebase.dart';
import 'package:fitween/src/model/class/model.dart';

export './dao/user.dart';
export './dao/party.dart';
export './dao/battle.dart';
export './dao/user/battle.dart';
export './dao/user/collection.dart';
export './dao/user/friend.dart';
export './dao/user/info.dart';
export './dao/user/notification.dart';
export './dao/user/party.dart';
export './dao/user/record.dart';

abstract class DAO<T extends Model> {
  String get collectionPath;
  get _collection => f.collection(collectionPath);

  Map<String, T> _list = {};
  Map<String, T> get list => _list;

  String get keyName;
  T fromJson(Map<String, dynamic> json);

  Future loadAll({bool lightMode = true}) async {
    _list = {};
    var jsonList = await _collection.get();
    for (var doc in jsonList.docs) {
      var json = doc.data();
      T obj = fromJson(json);
      obj = await afterLoad(obj, lightMode: lightMode);
      _list[json[keyName]] = obj;
    }
  }

  Future<T> afterLoad(T obj, {bool lightMode = true}) async { return obj; }

  Future<T?> loadOne(String key) async {
    var json = (await _collection.doc(key).get()).data();
    if (json == null) return null;
    T obj = fromJson(json);
    return await afterLoad(obj);
  }

  Future saveOne(T one) async {
    await _collection.doc(one.key).set(one.toJson());
  }

  Future beforeRemove(T obj) async {}

  Future removeOne(T one) async {
    await beforeRemove(one);
    await _collection.doc(one.key).delete();
  }

  void set(T one) => _list[one.key] = one;
}