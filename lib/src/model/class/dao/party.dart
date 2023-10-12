
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/class/model/party.dart';

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
  Future beforeRemove(Party one) async {
    for (String uid in one.memberUids) {
      FUserParty? loaded = await FUserPartyDAO().loadOne(uid);
      if (loaded == null) continue;
      loaded.removeParty(one.key);
      await FUserPartyDAO().saveOne(loaded);
    }
  }

  @override
  String get keyName => 'id';
}