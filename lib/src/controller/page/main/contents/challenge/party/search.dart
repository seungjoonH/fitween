import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PartySearchedType { code, title, leaderNickname, challengeTitle }

class PartySearchPageCont extends PageCont {
  static PartySearchPageCont get to => Get.find<PartySearchPageCont>();

  String get notFoundText => LangCont.tr('party-search.not-found');

  final _activeTypes = <FType, bool>{}.obs;
  Map<FType, bool> get activeTypes => _activeTypes;

  bool isActive(FType type) => activeTypes[type] ?? true;
  void updateTypeState(FType type) => activeTypes[type] = !isActive(type);

  final collections = f.collection('parties');
  final _searchedParties = <PartySearchedType, List<Party>>{}.obs;
  List<Party> get parties {
    Map<String, Party> map = {};
    int compare(Party a, Party b) => b.leftDays - a.leftDays;

    for (List<Party> partyList in _searchedParties.values) {
      for (Party p in partyList) { map[p.key] = p; }
    }
    List<Party> sorted = [...map.values]..sort(compare);
    return sorted;
  }

  String get searchHintText => LangCont.tr('search.party');

  final textEditingCont = TextEditingController();
  final _keyword = ''.obs;
  String get keyword => _keyword.value;

  PartySearchedType? getSearchedType(String id) {
    for (var type in PartySearchedType.values) {
      if (!_searchedParties[type]!.map((p) => p.key).contains(id)) continue;
      return type;
    }
    return null;
  }

  void partyListTilePressed(Party party) {
    FRoute.toParty(party: party); party.view(logged.key);
  }

  @override
  Future load() async {
    _activeTypes.assignAll({for (var type in FType.values) type : true});
    _searchedParties.assignAll({
      for (var type in PartySearchedType.values) type : <Party>[]
    });

    String word = Get.arguments as String;

    _keyword('');
    textEditingCont.clear();
    textEditingCont.text = word;

    onChanged(word);
  }

  @override
  String get loadKey => 'party-search';

  void onChanged(String text) => _keyword(text);

  @override
  void onInit() {
    super.onInit();
    ever(_activeTypes, (_) => streaming());
    ever(_keyword, (_) => streaming());
  }

  void streaming() async {
    if (keyword.trim().isEmpty) {
      for (var type in PartySearchedType.values) {
        _searchedParties[type] = <Party>[];
      }
      return;
    }

    List<String> searchingIds = ['@'];
    for (Challenge c in ChallengeLocal().list) {
      if (c.title.contains(keyword)) searchingIds.add(c.key);
    }

    var cols = collections
        .where('id', isEqualTo: keyword);

    cols.snapshots().listen((snapshot) {
      _searchedParties[PartySearchedType.code] = [
        ...snapshot.docs.map((doc) => Party.fromJson(doc.data()))
          ..where((party) => isActive(party.type)),
      ];
    });

    cols = collections
        .where('challengeId', whereIn: searchingIds);

    cols.snapshots().listen((snapshot) {
      _searchedParties[PartySearchedType.challengeTitle] = [
        ...snapshot.docs.map((doc) => Party.fromJson(doc.data()))
            .where((party) => isActive(party.type)),
      ];
    });

    cols = collections
        .orderBy('title')
        .startAt([keyword])
        .endAt(['$keyword\uf8ff']);

    cols.snapshots().listen((snapshot) {
      _searchedParties[PartySearchedType.title] = [
        ...snapshot.docs.map((doc) => Party.fromJson(doc.data()))
            .where((party) => isActive(party.type)),
      ];
    });

    cols = collections
        .orderBy('leaderNickname')
        .startAt([keyword])
        .endAt(['$keyword\uf8ff']);

    cols.snapshots().listen((snapshot) {
      _searchedParties[PartySearchedType.leaderNickname] = [
        ...snapshot.docs.map((doc) => Party.fromJson(doc.data()))
            .where((party) => isActive(party.type)),
      ];
    });

  }
}