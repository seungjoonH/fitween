import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model/party.dart';
import 'package:fitween/src/model/class/model/user.dart';
import 'package:fitween/src/model/enum/enum.dart';

class FUserParty extends FUser {
  @override
  FUserParty? get party => this;

  List<String> _partyIds = [];
  List<String> _appliedPartyIds = [];
  List<String> _finishedPartyIds = [];

  @override
  Map<String, Party> parties = {};

  @override
  Map<String, Party> appliedParties = {};

  @override
  Map<String, Party> finishedParties = {};

  Future loadAllParties() async {
    await loadParties();
    await loadAppliedParties();
    await loadFinishedParties();
  }

  Future loadParties() async {
    for (String id in _partyIds) {
      Party? loaded = await PartyDAO().loadOne(id);

      if (loaded == null) throw Exception('[ERROR] Party($id) load failed');
      parties[id] = loaded;
    }
  }

  Future loadAppliedParties() async {
    for (String id in _appliedPartyIds) {
      Party? loaded = await PartyDAO().loadOne(id);

      if (loaded == null) throw Exception('[ERROR] Applied Party($id) load failed');
      appliedParties[id] = loaded;
    }
  }

  Future loadFinishedParties() async {
    for (String id in _finishedPartyIds) {
      Party? loaded = await PartyDAO().loadOne(id);
      if (loaded == null) throw Exception('[ERROR] Finished Party($id) load failed');
      await loaded.loadMembers();
      finishedParties[id] = loaded;
    }
  }

  void addParty(Party party) {
    parties[party.key] = party;
    if (_partyIds.contains(party.key)) return;
    _partyIds.add(party.key);
  }

  void removeParty(String partyId) {
    _partyIds.remove(partyId);
    parties.remove(partyId);
  }

  void addToAppliedParties(Party party) {
    appliedParties[party.key] = party;
    if (_appliedPartyIds.contains(party.key)) return;
    _appliedPartyIds.add(party.key);
  }

  void removeFromAppliedParties(String partyId) {
    _appliedPartyIds.remove(partyId);
    appliedParties.remove(partyId);
  }

  bool hasProgressingPartyOf(FType type) {
    List<Party> list = parties.values.toList();
    return list.indexWhere((party) => party.type == type) >= 0;
  }

  bool hasAppliedPartyOf(FType type) {
    List<Party> list = appliedParties.values.toList();
    return list.indexWhere((party) => party.type == type) >= 0;
  }

  void finishParty(Party party) {
    _partyIds.remove(party.key);
    parties.remove(party.key);
    _finishedPartyIds.add(party.key);
    finishedParties[party.key] = party;
  }

  FUserParty(super.key) : super();
  FUserParty.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _partyIds = (json['partyIds'] ?? []).cast<String>();
    _appliedPartyIds = (json['appliedPartyIds'] ?? []).cast<String>();
    _finishedPartyIds = (json['finishedPartyIds'] ?? []).cast<String>();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['partyIds'] = _partyIds;
    json['appliedPartyIds'] = _appliedPartyIds;
    json['finishedPartyIds'] = _finishedPartyIds;
    return json;
  }

}