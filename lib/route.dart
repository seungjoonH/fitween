import 'package:fitween/src/view/page/abs/page.dart';
import 'package:fitween/src/view/page/concrete/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// class
class FRoute {
  /// static variables
// 화면 전환 트랜지션
  static const Transition transition = Transition.fadeIn;

// 화면 전환 지속시간
  static const Duration duration = Duration(milliseconds: 100);

  /// static methods
  // 라우트 문자열, 페이지 매핑
  static Map<String, Widget> get pages => {
    '/': const LoginPage(),
    '/onboarding': const OnboardingPage(),
    '/register': const RegisterPage(),
    '/goal-setting': const GoalSettingPage(),
    '/home': const HomePage(),

    // '/onboarding': const OnboardingPage(),
    // '/register': const RegisterPage(),
    // '/home': const HomePage(),
    // '/home/calendar': const CalendarPage(),
    // '/home/ranking': const RankingPage(),
    // '/friend': const FriendPage(),
    // '/contents': const ContentsPage(),
    // '/contents/challengeDetail': const ChallengeDetailPage(),
    // '/contents/party': const PartyPage(),
    // '/contents/achievementLevel': const AchievementLevelPage(),
    // '/contents/workout/friend': const WorkoutFriendPage(),
    // '/contents/workout/ready': const WorkoutReadyPage(),
    // '/contents/workout/solo/camera': const WorkoutSoloCameraPage(),
    // '/contents/workout/solo/result': const WorkoutSoloResultPage(),
    // '/contents/workout/battle/camera': const BattleCameraPage(),
    // '/contents/workout/battle/result': const BattleResultPage(),
    // '/contents/workout/battle/record': const BattleRecordPage(),
    // '/seeMore': const SeeMorePage(),
    // '/seeMore/collection': const CollectionPage(),
    // '/seeMore/goalEdit': const GoalEditPage(),
    // '/seeMore/infoEdit': const InfoEditPage(),
    // '/seeMore/appInfo': const AppInfoPage(),
    // '/seeMore/appInfo/license': const OSSLicensePage(),
    // '/seeMore/appInfo/license/detail': const LicenseDetailPage(),
    // '/seeMore/appInfo/webView': const WebViewPage(),
    // '/seeMore/appInfo/version': const VersionPage(),
    // '/seeMore/appInfo/report': const ReportPage(),
    // '/seeMore/appInfo/report/detail': const ReportDetailPage(),
    // '/seeMore/appInfo/report/edit': const ReportEditPage(),
  };

  // static List<GetPage> get getPages => pages.entries.map((page) {
  //   return GetPage(
  //     name: page.key,
  //     page: () => page.value,
  //     transition: transition,
  //     transitionDuration: page.key == '/contents/challengeDetail'
  //         ? const Duration(milliseconds: 500)
  //         : duration,
  //   );
  // }).toList();

  static List<GetPage> get getPages => pages.entries.map((page) {
    return GetPage(
      name: page.key,
      page: () => page.value,
      transition: transition,
      transitionDuration: duration,
    );
  }).toList();


  static void toLogin() => Get.offAllNamed('/');
  static void toOnboarding() => Get.toNamed('/onboarding');
  static void toRegister() => Get.toNamed('/register');
  static void toGoalSetting() => Get.toNamed('/goal-setting');
  static void toHome() => Get.offAllNamed('/home');
}
