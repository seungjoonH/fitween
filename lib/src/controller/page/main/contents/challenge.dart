import 'package:fitween/global/date.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class ChallengePageCont extends PageCont {
  static ChallengePageCont get to => Get.find<ChallengePageCont>();

  @override
  String get loadKey => 'challenge';

  String get appBarTitle => LangCont.tr('appbar.challenge');

  String get _tr => 'challenge.empty';
  String get emptyTitle => LangCont.tr('$_tr.title');
  String get emptyDescription => LangCont.tr('$_tr.description');

  final _challenges = <Challenge>[].obs;
  final _parties = <Party?>[].obs;

  List<Challenge> get challenges => _challenges;
  List<Party?> get parties => _parties;

  List<Challenge> challengesByType(FType type) {
    return _challenges.where((c) => c.type == type).toList();
  }

  bool isBookmarkedChallenge(Challenge challenge) {
    return parties.map((party) => party?.challenge!.key).contains(challenge.key);
  }

  // bool isBookmarkedTypeOfChallenge(Challenge challenge) {
  //   return parties.map((party) => party?.challenge!.type).contains(challenge.type);
  // }

  FUser get _logged => AuthCont.logged!;

  @override
  Future load() async {
    await _logged.party!.loadParties();
    _challenges.assignAll(ChallengeLocal().list);
    _parties.assignAll(List.generate(FType.activeValues.length, (i) => null));
    for (Party p in _logged.parties.values) {
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

