
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:get/get.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/presenter/firebase/firebase.dart';

/// class
// 파이어베이스 파티 관련
class PartyJsonP extends GetxController {
  final userPartyP = Get.find<UserPartyP>();

  List<Party> parties = [];

  // 파이어베이스에서 해당 아이디의 파티 존재 여부 반환
  static Future<bool> partyExists(String id) async {
    if (id == '') return false;
    return (await f.collection('parties').doc(id).get()).exists;
  }

  // 파이어베이스에서 해당 아이디의 파티 만원 여부 반환
  static Future<bool> partyFulled(String id) async {
    if (id == '') return false;
    var json = (await f.collection('parties').doc(id).get()).data();
    if (json == null) return false;
    Party party = Party.fromJson(json);

    return party.level['maxMember'] <= party.memberUids.length;
  }

  // 파이어베이스에서 전체 파티 리스트 로드 (사용 지양)
  Future loadAll() async {
    parties.clear();
    for (var doc in (await f.collection('parties').get()).docs) {
      parties.add(Party.fromJson(doc.data()));
    }
  }

  // 파이어베이스에서 해당 아이디의 파티를 로드
  static Future<Party?> loadParty(String id) async {
    var json = (await f.collection('parties').doc(id).get()).data();
    if (json == null) return null;
    return Party.fromJson(json);
  }

  // 파이어베이스에서 해당 파티의 멤버 리스트를 로드
  static Future loadMembers(Party party) async {
    List<FUserInfo> memberInfos = [];
    List<FUserCollection> memberCollections = [];
    List<FUserRecord> memberRecords = [];

    for (var uid in party.memberUids) {
      FUserInfo? userInfo = await UserInfoP.loadUser(uid);
      FUserCollection? userCollection = await UserCollectionP.loadUser(uid);
      FUserRecord? userRecord = await UserRecordP.loadUser(uid);

      if (userInfo == null) continue;
      if (userCollection == null) continue;
      if (userRecord == null) continue;

      memberInfos.add(userInfo);
      memberCollections.add(userCollection);
      memberRecords.add(userRecord);
    }
    party.memberInfos = [...memberInfos];
    party.memberCollections = [...memberCollections];
    party.memberRecords = [...memberRecords];
  }

  static void deleteMember(String uid) async {
    var jsonList = (await f.collection('parties').get()).docs;

    for (var data in jsonList) {
      Map<String, dynamic> json = data.data();
      Party party = Party.fromJson(json);

      party.records.remove(uid);
      save(party);

      if (party.leaderUid == uid) delete(party.id!);
    }
  }

  static void delete(String id) async {
    Party? party = await loadParty(id);
    deletePartyIdFromUser(id, party!.memberUids);
    f.collection('parties').doc(id).delete();
  }

  static deletePartyIdFromUser(String id, List<String> uids) async {
    for (String uid in uids) {
      FUserParty? user = await UserPartyP.loadUser(uid);
      if (user == null) continue;
      user.partyIds.remove(id);
      UserPartyP.saveUser(user);
    }
  }

  // 파이어베이스에 해당 파티를 최신화
  static void save(Party party) {
    f.collection('parties').doc(party.id).set(party.toJson());
  }

}