import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/battle.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:get/get.dart';

class BattleJsonP {
  static Map<String, FUserInfo> loadedInfos = {};
  static Map<String, FUserCollection> loadedCollections = {};

  static Future<String> get nextBattleId async {
    var jsonList = await f.collection('battles').orderBy('genDate').get();
    Iterable<String> list = jsonList.docs.map((e) => e.id);
    int nextNumber = list.isEmpty ? 0 : int.parse(jsonList.docs.map((e) => e.id).last) + 1;
    return '$nextNumber'.padLeft(8, '0');
  }

  static Future<Battle?> load(String id) async {
    var json = (await f.collection('battles').doc(id).get()).data();
    if (json == null) return null;
    Battle loadedBattle = Battle.fromJson(json);

    loadedBattle.memberInfos = {};
    loadedBattle.memberCollections = {};

    for (String uid in loadedBattle.data.keys) {
      FUserInfo? memberInfo;
      FUserCollection? memberCollection;

      if (loadedInfos[uid] == null) {
        memberInfo = await UserInfoP.loadUser(uid);
        loadedInfos[uid] = memberInfo!;
      }
      else { memberInfo = loadedInfos[uid]; }

      if (loadedCollections[uid] == null) {
        memberCollection = await UserCollectionP.loadUser(uid);
        loadedCollections[uid] = memberCollection!;
      }
      else { memberCollection = loadedCollections[uid]; }

      if (memberInfo != null) loadedBattle.memberInfos[uid] = memberInfo;
      if (memberCollection != null) loadedBattle.memberCollections[uid] = memberCollection;
    }

    if (loadedBattle.finished && !(loadedBattle.applied ?? false)) {
      FUserInfo? winnerInfo = loadedBattle.winnerInfo;
      FUserInfo? loserInfo = loadedBattle.loserInfo;

      winnerInfo ??= loadedBattle.memberInfos.values.first;
      loserInfo ??= loadedBattle.memberInfos.values.last;

      FUserFriend? winner = await UserFriendP.loadUser(winnerInfo.uid!);
      FUserFriend? loser = await UserFriendP.loadUser(loserInfo.uid!);

      if (winner != null && loser != null) {
        if (loadedBattle.tied) {
          winner.draw(loser.uid!);
          loser.draw(winner.uid!);
        }
        else {
          winner.win(loser.uid!);
          loser.lose(winner.uid!);
        }

        UserFriendP.saveUser(winner);
        UserFriendP.saveUser(loser);
      }

      loadedBattle.apply();
      save(loadedBattle);
    }

    return loadedBattle;
  }

  static void save(Battle battle) async {
    Map<String, dynamic> json = battle.toJson();
    f.collection('battles').doc(battle.id).set(json);
  }

  static Future<String> createNewBattle(String uid) async {
    final userP = Get.find<UserInfoP>();
    String nextId = await nextBattleId;
    Battle newBattle = Battle.fromJson({
      'id': nextId,
      'genDate': toTimestamp(now),
      'data': <String, dynamic>{
        userP.loggedUser.uid!: {'attempts': <int>[], 'chance': 1},
        uid: {'attempts': <int>[], 'chance': 2},
      },
    });
    save(newBattle);
    return nextId;
  }

  static Future complete(String id, int count) async {
    final userP = Get.find<UserInfoP>();
    Battle? battle = await load(id);
    if (battle == null) return;

    battle.complete(userP.loggedUser.uid!, count);
    save(battle);
  }

  static Future reduceChance(String id) async {
    final userP = Get.find<UserInfoP>();
    Battle? battle = await load(id);
    if (battle == null) return;

    battle.reduceChance(userP.loggedUser.uid!);
    save(battle);
  }
}