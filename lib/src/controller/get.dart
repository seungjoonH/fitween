import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class GetCont {
  static void _initPageConts() {
    Get.put(LoginPageCont());
    Get.put(OnboardingPageCont());
    Get.put(RegisterPageCont());
    Get.put(GoalSettingPageCont());
    Get.put(HomePageCont());
    Get.put(CalendarPageCont());
    Get.put(RankingPageCont());
    Get.put(FriendPageCont());
    Get.put(FriendSearchPageCont());
    Get.put(ContentsPageCont());
    Get.put(AdventurePageCont());
    Get.put(LevelDetailPageCont());
    Get.put(ChallengePageCont());
    Get.put(PartyPageCont());
    Get.put(ChallengeDetailPageCont());
    Get.put(PartyCreatePageCont());
    Get.put(PartyMemberSettingPageCont());
    Get.put(PartySearchPageCont());
    Get.put(PartyApplicantsPageCont());
    Get.put(PartyHistoryPageCont());
    Get.put(FPointPageCont());
    Get.put(FPointHistoryPageCont());
    Get.put(WeightPageCont());
    Get.put(BattlePageCont());
    Get.put(ContentsPageCont());
    Get.put(SeeMorePageCont());
    Get.put(NotificationPageCont());
    Get.put(SettingsPageCont());
    Get.put(GeneralSettingPageCont());
    Get.put(AppInfoPageCont());
    Get.put(TermsInUsePageCont());
    Get.put(PrivacyPolicyPageCont());
    Get.put(SupportPageCont());
    Get.put(VersionPageCont());
    Get.put(PatchNotePageCont());
    Get.put(OSSLicensesPageCont());
    Get.put(LicenseDetailPageCont());
    Get.put(FitweenPageCont());
  }

  static void _userConts() {
    Get.put(FollowCont());
    Get.put(FPointCont());
  }

  static void _initValidatorConts() {
    Get.put(NicknameValidatorCont());
    Get.put(DateOfBirthValidatorCont());
  }

  static void _etcConts() {
    Get.put(LoadingCont());
    Get.put(CalendarCont());
    Get.put(NotificationCont());
    Get.put(RankingCont());
    Get.put(BottomBarCont());
  }

  static void initConts() {
    _initPageConts();
    _userConts();
    _initValidatorConts();
    _etcConts();
  }
}