import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class ChallengeDetailPageCont extends PageCont {
  static ChallengeDetailPageCont get to => Get.find<ChallengeDetailPageCont>();

  final _challenge = Rx<Challenge?>(null);
  Challenge? get challenge => _challenge.value;

  Party getPartyFromChallenge() {
    return _logged.parties.values
        .firstWhere((party) => challenge!.key == party.challenge!.key);
  }

  String get _tr => 'challenge-detail';
  String get goPartyText => LangCont.tr('$_tr.go-party');
  String get joinPartyText => LangCont.tr('$_tr.join-party');
  String get createPartyText => LangCont.tr('$_tr.create-party');

  bool get isBookmarkedChallenge {
    return _logged.parties.values
        .map((party) => party.challenge!.key)
        .contains(challenge!.key);
  }

  bool get isBookmarkedTypeOfChallenge {
    return _logged.parties.values
        .map((party) => party.challenge!.type)
        .contains(challenge!.type);
  }

  void goToMyPartyButtonPressed() {
    Get.back();
    FRoute.toParty(party: getPartyFromChallenge());
  }

  void createPartyButtonPressed() {
    FRoute.toPartyCreate(challenge: challenge);
  }

  FUser get _logged => AuthCont.logged!;

  @override
  Future load() async {
    _challenge.value = Get.arguments as Challenge;
  }

  @override
  String get loadKey => 'challenge-detail';

}