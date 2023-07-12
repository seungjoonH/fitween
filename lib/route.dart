/* 라우트 관련 */
import 'package:fitween/view/page/contents/workout/battle/record/record.dart';
import 'package:fitween/view/page/contents/workout/friend/friend.dart';
import 'package:fitween/view/page/contents/workout/ready/ready.dart';
import 'package:fitween/view/page/contents/workout/battle/camera/camera.dart';
import 'package:fitween/view/page/contents/workout/battle/result/result.dart';
import 'package:fitween/view/page/contents/workout/solo/camera/camera.dart';
import 'package:fitween/view/page/contents/workout/solo/result/result.dart';
import 'package:fitween/view/page/see_more/app_info/app_info.dart';
import 'package:fitween/view/page/see_more/app_info/license/detail.dart';
import 'package:fitween/view/page/see_more/app_info/license/license.dart';
import 'package:fitween/view/page/see_more/app_info/version.dart';
import 'package:fitween/view/page/see_more/app_info/web_view.dart';
import 'package:fitween/view/page/see_more/collection/collection.dart';
import 'package:fitween/view/page/contents/achievement/level/level.dart';
import 'package:fitween/view/page/contents/challenge/detail/detail.dart';
import 'package:fitween/view/page/contents/challenge/party/party.dart';
import 'package:fitween/view/page/contents/contents.dart';
import 'package:fitween/view/page/friend/friend.dart';
import 'package:fitween/view/page/home/calendar/calendar.dart';
import 'package:fitween/view/page/home/home.dart';
import 'package:fitween/view/page/home/ranking/ranking.dart';
import 'package:fitween/view/page/login/login.dart';
import 'package:fitween/view/page/onboarding/onboarding.dart';
import 'package:fitween/view/page/register/register.dart';
import 'package:fitween/view/page/see_more/goal_edit/goal_edit.dart';
import 'package:fitween/view/page/see_more/info_edit/info_edit.dart';
import 'package:fitween/view/page/see_more/see_more.dart';
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
    '/login': const LoginPage(),
    '/onboarding': const OnboardingPage(),
    '/register': const RegisterPage(),
    '/home': const HomePage(),
    '/home/calendar': const CalendarPage(),
    '/home/ranking': const RankingPage(),
    '/friend': const FriendPage(),
    '/contents': const ContentsPage(),
    '/contents/challengeDetail': const ChallengeDetailPage(),
    '/contents/party': const PartyPage(),
    '/contents/achievementLevel': const AchievementLevelPage(),
    '/contents/workout/friend': const WorkoutFriendPage(),
    '/contents/workout/ready': const WorkoutReadyPage(),
    '/contents/workout/solo/camera': const WorkoutSoloCameraPage(),
    '/contents/workout/solo/result': const WorkoutSoloResultPage(),
    '/contents/workout/battle/camera': const BattleCameraPage(),
    '/contents/workout/battle/result': const BattleResultPage(),
    '/contents/workout/battle/record': const BattleRecordPage(),
    '/seeMore': const SeeMorePage(),
    '/seeMore/collection': const CollectionPage(),
    '/seeMore/goalEdit': const GoalEditPage(),
    '/seeMore/infoEdit': const InfoEditPage(),
    '/seeMore/appInfo': const AppInfoPage(),
    '/seeMore/appInfo/license': const OSSLicensePage(),
    '/seeMore/appInfo/license/detail': const LicenseDetailPage(),
    '/seeMore/appInfo/webView': const WebViewPage(),
    '/seeMore/appInfo/version': const VersionPage(),
  };

  // 겟페이지 리스트
  static List<GetPage> get getPages => pages.entries.map((page) {
    return GetPage(
      name: page.key,
      page: () => page.value,
      transition: transition,
      transitionDuration: page.key == '/contents/challengeDetail'
          ? const Duration(milliseconds: 500)
          : duration,
    );
  }).toList();
}
