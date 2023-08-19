
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model/party.dart';
import 'package:fitween/src/model/class/model/user.dart';

class PartyDAO extends DAO<Party> {
  static final PartyDAO _instance = PartyDAO._();
  PartyDAO._();

  factory PartyDAO() => _instance;

  @override
  String get collectionPath => 'parties';

  @override
  Party fromJson(Map<String, dynamic> json) {
    return Party.fromJson(json);
  }

  @override
  String get keyName => 'id';

  Future<FUser> _loadLeader(Party party, {bool lightMode = true}) async {
    String uid = party.leaderUid;
    return (lightMode
        ? await FUserInfoDAO().loadOne(uid)
        : await FUserDAO().loadOne(uid))!;
  }

  Future<List<FUser>> _loadMembers(Party party, {bool lightMode = true}) async {
    List<FUser> members = [];
    if (lightMode) return members;
    for (String uid in party.memberUids) {
      members.add((await FUserDAO().loadOne(uid))!);
    }
    return members;
  }

  @override
  Future<Party> afterLoad(Party obj, {bool lightMode = true}) async {
    obj.leader = await _loadLeader(obj, lightMode: lightMode);
    obj.members = await _loadMembers(obj, lightMode: lightMode);
    return obj;
  }

  @override
  Future beforeRemove(Party obj) async {
    if (!obj.memberLoaded) obj.members = await _loadMembers(obj, lightMode: false);
    for (FUser user in obj.members) {
      await FUserPartyDAO().removeParty(user.party!, obj.key);
    }
  }
}