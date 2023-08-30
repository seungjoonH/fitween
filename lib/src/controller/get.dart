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
    Get.put(FriendPageCont());
    Get.put(ContentsPageCont());
    Get.put(SeeMorePageCont());
  }

  static void _initValidatorConts() {
    Get.put(NicknameValidatorCont());
    Get.put(DateOfBirthValidatorCont());
  }

  static void _etcConts() {
    Get.put(LoadingCont());
    Get.put(CalendarCont());
    Get.put(RankingCont());
    Get.put(BottomBarCont());
  }

  static void initConts() {
    _initPageConts();
    _initValidatorConts();
    _etcConts();
  }
}