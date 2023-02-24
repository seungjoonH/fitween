/* 사용자 모델 프리젠터 */
import 'package:fitween/model/class/database/user/party.dart';
import 'package:get/get.dart';
import 'package:fitween/model/class/json/challenge.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/enum/difficulty.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/model/party.dart';

/// class
// 사용자 객체 관련
class UserPartyP extends GetxController {
  /// static variables
  static get collection => f.collection('userParties');

  /// static methods
  static Future<FUserParty?> loadUser(String uid) async {
    var json = (await collection.doc(uid).get()).data();
    if (json == null) return null;
    return FUserParty.fromJson(json);
  }

  static void saveUser(FUserParty user) async {
    collection.doc(user.uid).set(user.toJson());
  }

  /// attributes
  /* 로그인 관련 */

  // 현재 로그인된 사용자
  FUserParty loggedUser = FUserParty();

  /// methods
  /* 로그인 관련 */
  // 로그인
  // 매개변수로 받은 사용자 정보와 User Credential 정보를 병합하여 현재 로그인된 사용자자 최신화
  Future login(FUserParty user) async {
    Map<String, dynamic> json = user.toJson();
    loggedUser = FUserParty.fromJson(json);
    save();
  }

  // 로그아웃
  // 현재 로그인된 사용자 정보 초기화
  void logout() => loggedUser = FUserParty();

  /* 파이어베이스 관련 */
  // 파이어베이스에서 로드
  Future load() async {
    var json = (await collection.doc(loggedUser.uid).get()).data();
    if (json == null) return;
    loggedUser = FUserParty.fromJson(json);
  }

  // 파이어베이스에 최신화
  void save() => collection.doc(loggedUser.uid).set(loggedUser.toJson());

  // 파이어베이스에서 삭제
  void delete() {
    PartyPresenter.deleteMember(loggedUser.uid!);
    collection.doc(loggedUser.uid).delete();
  }

  // 챌린지와 난이도에 따른 새로운 파티 생성, 해당 파티 코드 반환
  // 로그인된 사용자가 직접 파티를 생성하는 경우
  Future<String> createMyParty(Challenge challenge, Difficulty diff) async {
    String code = FUserParty.randomCode;

    Party newParty = Party.fromJson({
      'id': code,
      'complete': false,
      'challengeId': challenge.id,
      'difficulty': diff.name,
      'records': <String, dynamic>{loggedUser.uid!: 0},
      'leaderUid': loggedUser.uid,
    });

    loggedUser.parties[code] = newParty;
    await PartyPresenter.loadMembers(newParty);
    PartyPresenter.save(newParty);

    loggedUser.partyIds.add(newParty.id!);
    save();

    update();

    return code;
  }

  // 파이어베이스에서 나의 파티 리스트 로드
  Future loadMyParties() async {
    for (String id in loggedUser.partyIds) {
      var json = (await f.collection('parties').doc(id).get()).data();
      if (json == null) return;
      Party party = Party.fromJson(json);
      await PartyPresenter.loadMembers(party);
      loggedUser.parties[json['id']] = party;
    }
    print(loggedUser.parties);
    update();
  }

  // 해당 아이디의 파티에 참가
  // 로그인된 사용자가 직접 참가하는 경우
  void joinParty(String id) {
    if (loggedUser.partyIds.contains(id)) return;
    loggedUser.partyIds.add(id);
    save();
  }

  // 로그인된 사용자가 해당 아이디의 챌린지에 이미 참여 중인지 여부 반환
  bool alreadyJoinedChallenge(String challengeId) {
    return loggedUser.parties.values
        .map((party) => party.challengeId)
        .contains(challengeId);
  }

  // 로그인된 사용자가 해당 코드의 파티에 이미 참여 중인지 여부 반환
  bool alreadyJoinedParty(String code) {
    return loggedUser.parties.values.map((party) => party.id).contains(code);
  }

  // 로그인된 사용자가 해당 아이디의 파티가 있을 경우 파티 객체 반환
  // 그렇지 않은 경우 null 반환
  Party? getPartyByChallengeId(String challengeId) {
    return loggedUser.parties.values
        .toList()
        .firstWhereOrNull((party) => party.challengeId == challengeId);
  }
}
