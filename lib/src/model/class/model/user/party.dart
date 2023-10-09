import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model/party.dart';
import 'package:fitween/src/model/class/model/user.dart';

class FUserParty extends FUser {
  @override
  FUserParty? get party => this;

  List<String> _partyIds = [];

  @override
  Map<String, Party> parties = {};

  Future loadParties() async {
    for (String id in _partyIds) {
      Party? loaded = await PartyDAO().loadOne(id);

      if (loaded == null) throw Exception('[ERROR] Party($id) load failed');
      parties[id] = loaded;
    }
  }

  void addParty(Party party) {
    _partyIds.add(party.key);
    parties[party.key] = party;
  }

  void removeParty(String partyId) {
    _partyIds.remove(partyId);
    parties.remove(partyId);
  }

  FUserParty(super.key) : super();
  FUserParty.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _partyIds = (json['partyIds'] ?? []).cast<String>();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['partyIds'] = _partyIds;
    return json;
  }

}