import 'dart:ui';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:get/get.dart';

class PartyApplicantsPageCont extends PageCont {
  static PartyApplicantsPageCont get to => Get.find<PartyApplicantsPageCont>();

  String get appBarTitle => LangCont.tr('appbar.applicants');

  final _party = Rx<Party?>(null);
  Party? get party => _party.value;
  // void setParty(Party party) => _party.value = party;

  String get listHeaderText => '$appBarTitle ${LangCont.tr('word.list').capitalize!}';

  final _applicants = <String, FUser>{}.obs;
  Map<String, FUser> get applicants => _applicants;

  String get _tr => 'party-applicants';
  String get noApplicantsText => LangCont.tr('$_tr.no-applicants');

  String get acceptButtonText => LangCont.tr('button.accept');
  String get rejectButtonText => LangCont.tr('button.reject');

  void _removeApplicant(String uid) {
    _applicants.remove(uid);
    party!.removeApplicant(uid);
  }

  String get _dialogTr => '$_tr.dialog';
  String get reallyAcceptTitle => LangCont.tr('$_dialogTr.accept.really-title');
  String get reallyRejectTitle => LangCont.tr('$_dialogTr.reject.really-title');

  String getReallyAcceptText(FUser user) => LangCont.tr(
    '$_dialogTr.accept.really-text', namedArgs: {'nickname': user.nickname},
  );
  String getReallyRejectText(FUser user) => LangCont.tr(
    '$_dialogTr.reject.really-text', namedArgs: {'nickname': user.nickname},
  );

  String get acceptedTitle => LangCont.tr('$_dialogTr.accept.complete-title');
  String get rejectedTitle => LangCont.tr('$_dialogTr.reject.complete-title');

  String getAcceptedText(FUser user) => LangCont.tr(
    '$_dialogTr.accept.complete-text', namedArgs: {'nickname': user.nickname},
  );
  String getRejectedText(FUser user) => LangCont.tr(
    '$_dialogTr.reject.complete-text', namedArgs: {'nickname': user.nickname},
  );

  void acceptButtonPressed(FUser applicant) {
    showFDialog(
      title: reallyAcceptTitle,
      content: FTexts(
        getReallyAcceptText(applicant),
        style: FTheme.bodyLarge,
        highlightStyle: FTheme.bodyLarge?.copyWith(
          color: party!.type.color,
          fontWeight: FontWeight.bold,
        ),
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightText: acceptButtonText,
      rightPressed: () => _accept(applicant),
    );
  }

  void rejectButtonPressed(FUser applicant) {
    showFDialog(
      title: reallyRejectTitle,
      content: FTexts(
        getReallyRejectText(applicant),
        style: FTheme.bodyLarge,
        highlightStyle: FTheme.bodyLarge?.copyWith(
          color: party!.type.color,
          fontWeight: FontWeight.bold,
        ),
        wordWrap: true,
      ),
      type: DialogType.bi,
      rightText: rejectButtonText,
      rightBackgroundColor: FTheme.error,
      rightPressed: () => _reject(applicant),
    );
  }

  void _accept(FUser applicant) async {
    await showFDialog(
      title: acceptedTitle,
      content: FTexts(
        getAcceptedText(applicant),
        style: FTheme.bodyLarge,
        highlightStyle: FTheme.bodyLarge?.copyWith(
          color: party!.type.color,
          fontWeight: FontWeight.bold,
        ),
        wordWrap: true,
      ),
      type: DialogType.mono,
    );

    _removeApplicant(applicant.key);
    await party!.addMember(applicant);
    await PartyDAO().saveOne(party!);

    applicant.party!.removeFromAppliedParties(party!.key);
    applicant.party!.addParty(party!);
    await FUserPartyDAO().saveOne(applicant.party!);

    applicant.notification!.acceptApplicant(party!);
    await FUserNotificationDAO().saveOne(applicant.notification!);

    await PartyPageCont.to.onRefresh();
  }

  void _reject(FUser applicant) async {
    await showFDialog(
      title: rejectedTitle,
      content: FTexts(
        getRejectedText(applicant),
        style: FTheme.bodyLarge,
        highlightStyle: FTheme.bodyLarge?.copyWith(
          color: party!.type.color,
          fontWeight: FontWeight.bold,
        ),
        wordWrap: true,
      ),
      type: DialogType.mono,
    );

    _removeApplicant(applicant.key);
    await PartyDAO().saveOne(party!);

    applicant.party!.removeFromAppliedParties(party!.key);
    await FUserPartyDAO().saveOne(applicant.party!);

    applicant.notification!.rejectApplicant(party!);
    await FUserNotificationDAO().saveOne(applicant.notification!);

    await PartyPageCont.to.onRefresh();
  }

  @override
  Future load() async {
    _party.value = Get.arguments as Party;
    await party!.loadApplicants();
    _applicants.assignAll({...party!.applicants});
  }

  @override
  String get loadKey => 'party-applicants';

}