import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserPartyDAO extends DAO<FUserParty> {
  static final FUserPartyDAO _instance = FUserPartyDAO._();
  FUserPartyDAO._();

  factory FUserPartyDAO() => _instance;

  @override
  String get collectionPath => 'userParties';

  @override
  FUserParty fromJson(Map<String, dynamic> json) {
    return FUserParty.fromJson(json);
  }

  @override
  String get keyName => 'uid';

  Future removeParty(FUserParty user, String partyId) async {
    user.removeParty(partyId);
    await saveOne(user);
    set(user);
  }
}