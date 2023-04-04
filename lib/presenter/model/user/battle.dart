import 'package:fitween/model/class/database/battle.dart';
import 'package:fitween/model/class/database/user/battle.dart';
import 'package:fitween/presenter/model/json/battle.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/firebase/firebase.dart';

/// class
// 사용자 객체 관련
class UserBattleP extends GetxController {
  /// static variables
  static get collection => f.collection('userBattles');
  static get doc {
    final userP = Get.find<UserBattleP>();
    return collection.doc(userP.loggedUser.uid);
  }

  /// static methods
  static Future<FUserBattle?> loadUser(String uid) async {
    var json = (await collection.doc(uid).get()).data();
    if (json == null) return null;
    return FUserBattle.fromJson(json);
  }

  static void saveUser(FUserBattle user) async {
    collection.doc(user.uid).set(user.toJson());
  }

  /// attributes
  /* 로그인 관련 */
  // 현재 로그인된 사용자
  FUserBattle loggedUser = FUserBattle();

  // 로그인 여부
  bool get isLogged => loggedUser.uid != null;

  /// methods
  /* 로그인 관련 */
  // 로그인
  // 매개변수로 받은 사용자 정보와 User Credential 정보를 병합하여 현재 로그인된 사용자자 최신화
  Future login(FUserBattle user) async {
    Map<String, dynamic> json = user.toJson();
    loggedUser = FUserBattle.fromJson(json);
    save();
  }

  // 로그아웃
  // 현재 로그인된 사용자 정보 초기화
  void logout() => loggedUser = FUserBattle();

  /* 파이어베이스 관련 */
  // 파이어베이스에서 로드
  Future load() async {
    var json = (await collection
        .doc(loggedUser.uid).get()).data();
    if (json == null) return;
    loggedUser = FUserBattle.fromJson(json);
  }

  // 파이어베이스에 최신화
  void save() => collection
      .doc(loggedUser.uid)
      .set(loggedUser.toJson());

  // 파이어베이스에서 삭제
  void delete() => collection
      .doc(loggedUser.uid).delete();

  Future loadMyBattles() async {
    List<String> ids = [...loggedUser.battlesData.keys];
    for (String id in ids) {
      Battle? battle = await BattleJsonP.load(id);
      if (battle == null) return;
      loggedUser.battles[id] = battle;
    }
    update();
  }

  Future<String> applyBattle(String uid) async {
    String battleId = await BattleJsonP.createNewBattle(uid);
    loggedUser.battlesData[battleId] = BattleData();
    save();

    FUserBattle rival = await UserBattleP.loadUser(uid)
        ?? FUserBattle()..uid = uid;
    rival.battlesData[battleId] = BattleData();
    UserBattleP.saveUser(rival);
    update();
    return battleId;
  }

  void hideBattle(String id) {
    loggedUser.hideBattle(id); save(); update();
  }
}
