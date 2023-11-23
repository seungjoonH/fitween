import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FriendSearchPageCont extends PageCont {
  static FriendSearchPageCont get to => Get.find<FriendSearchPageCont>();

  final collections = f.collection('userInfos');
  final _infos = <FUserInfo>[].obs;
  final _users = <String, FUser>{}.obs;
  List<FUser?> get users => _infos.map((info) => _users[info.key]).toList();

  String get searchHintText => LangCont.tr('search.nickname');

  final textEditingCont = TextEditingController();
  final _keyword = ''.obs;
  String get keyword => _keyword.value;

  @override
  String get loadKey => 'search';

  @override
  Future load() async {
    textEditingCont.clear();
    _keyword('');
  }

  void backPressed() {
    textEditingCont.clear();
    _keyword('');
    BottomBarCont.to.navigate(1);
  }

  void onChanged(String text) async {
    _keyword(text);
    await _loadCollections();
  }

  @override
  void onInit() {
    super.onInit();
    ever(_keyword, (_) => streaming());
  }

  void streaming() async {
    if (keyword.isEmpty) { _infos.clear(); return; }

    var cols = collections
        .orderBy('nickname')
        .startAt([keyword])
        .endAt(['$keyword\uf8ff']);

    cols.snapshots().listen((snapshot) => _infos.assignAll(
      snapshot.docs.map((doc) => FUserInfo.fromJson(doc.data()))),
    );
  }

  Future _loadCollections() async {
    List<FUserInfo> infos = [];
    await delay(50.ms, () => infos = [..._infos]);

    for (FUserInfo info in infos) {
      FUserLoadCont cont = FUserLoadCont.onlyCollection();
      FUser? loaded = await FUserDAO().loadOne(info.key, cont: cont);
      if (loaded == null) continue;
      if (_users.keys.contains(info.key)) continue;
      _users[info.key] = loaded;
    }
  }
}