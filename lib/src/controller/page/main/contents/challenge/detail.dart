import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:get/get.dart';

class ChallengeDetailPageCont extends PageCont {
  static ChallengeDetailPageCont get to => Get.find<ChallengeDetailPageCont>();

  final _challenge = Rx<Challenge?>(null);
  Challenge? get challenge => _challenge.value;

  Party getPartyFromChallenge() {
    return _logged.parties.values
        .firstWhere((party) => challenge!.key == party.challenge!.key);
  }

  Party getAppliedPartyFromChallenge() {
    return _logged.appliedParties.values
        .firstWhere((party) => challenge!.key == party.challenge!.key);
  }

  String get _tr => 'challenge-detail';
  String get goToMyPartyText => LangCont.tr('$_tr.my-party');
  String get goToAppliedPartyText => LangCont.tr('$_tr.applied-party');
  String get searchPartyText => LangCont.tr('$_tr.search-party');
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

  bool get isAppliedChallenge {
    return _logged.appliedParties.values
        .map((party) => party.challenge!.key)
        .contains(challenge!.key);
  }
  
  bool get isAppliedTypeOfChallenge {
    return _logged.appliedParties.values
        .map((party) => party.challenge!.type)
        .contains(challenge!.type);
  }

  void goToMyPartyButtonPressed() {
    Get.back();
    FRoute.toParty(party: getPartyFromChallenge());
  }

  void goToAppliedPartyButtonPressed() {
    Get.back();
    FRoute.toParty(party: getAppliedPartyFromChallenge());
  }

  String get unbookmarkTitle => LangCont.tr('$_tr.dialog.unbookmark-title');
  String get unbookmarkText => LangCont.tr('$_tr.dialog.unbookmark-text');
  String get cancelTitle => LangCont.tr('$_tr.dialog.cancel-title');
  String get cancelText => LangCont.tr('$_tr.dialog.cancel-text');

  void _showUnbookmarkDialog() async {
    await showFDialog(
      title: unbookmarkTitle,
      content: FText(unbookmarkText, maxLines: 0),
      type: DialogType.mono,
    );
  }

  void _showCancelDialog() async {
    await showFDialog(
      title: cancelTitle,
      content: FText(cancelText, maxLines: 0),
      type: DialogType.mono,
    );
  }

  void searchPartyButtonPressed() async {
    if (isBookmarkedTypeOfChallenge) { _showUnbookmarkDialog(); return; }
    if (isAppliedTypeOfChallenge) { _showCancelDialog(); return; }
    FRoute.toPartySearch(keyword: challenge!.title);
  }

  void createPartyButtonPressed() async {
    if (isBookmarkedTypeOfChallenge) { _showUnbookmarkDialog(); return; }
    if (isAppliedTypeOfChallenge) { _showCancelDialog(); return; }
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