import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class ChallengePageCont extends PageCont {
  static ChallengePageCont get to => Get.find<ChallengePageCont>();

  String get appBarTitle => LangCont.tr('appbar.challenge');

  String get _tr => 'challenge.empty';
  String get emptyTitle => LangCont.tr('$_tr.title');
  String get emptyDescription => LangCont.tr('$_tr.description');

  final _challenges = <Challenge>[].obs;
  final _parties = <Party?>[].obs;

  List<Challenge> get challenges => _challenges;
  List<Party?> get parties => _parties;

  List<Challenge> challengesByType(FType type) {
    List<Challenge> list = [..._challenges.where((c) => c.type == type)];
    int compare(Challenge a, Challenge b) => isBookmarkedChallenge(b) ? 1 : -1;
    return list..sort(compare);
  }

  bool isBookmarkedChallenge(Challenge challenge) {
    return parties.map((party) => party?.challenge!.key).contains(challenge.key);
  }

  // bool isBookmarkedTypeOfChallenge(Challenge challenge) {
  //   return parties.map((party) => party?.challenge!.type).contains(challenge.type);
  // }

  FUser get _logged => AuthCont.logged!;

  @override
  String get loadKey => 'challenge';

  @override
  Future load() async {
    _logged.party = await FUserPartyDAO().loadOne(_logged.key);
    await _logged.party!.loadParties();
    _challenges.assignAll(ChallengeLocal().list);
    _parties.assignAll(List.generate(FType.activeValues.length, (i) => null));

    List<Party> partyList = [..._logged.parties.values];
    for (Party p in partyList) {
      int toReplace = p.type.index - 1;
      await p.loadMembers();
      _parties.removeAt(toReplace);
      _parties.insert(toReplace, p);
    }
  }

  final _selectedType = FType.distance.obs;
  FType get selectedType => _selectedType.value;

  Party? getPartyByType(FType type) {
    if (parties.isEmpty) return null;
    return parties[type.index - 1];
  }

  void changeType(FType type) { _selectedType(type); }
  void partyWidgetPressed(FType type) {
    Party? party = parties[type.index - 1];
    if (party != null) FRoute.toParty(party: party);
    changeType(type);
  }

  void challengeCardPressed(Challenge challenge) {
    FRoute.toChallengeDetail(challenge: challenge);
  }
}

