/* 라우트 관련 */
import 'package:fitween/view/page/collection/main/main.dart';
import 'package:fitween/view/page/contents/achievement/level/level.dart';
import 'package:fitween/view/page/contents/challenge/detail/detail.dart';
import 'package:fitween/view/page/contents/challenge/party/party.dart';
import 'package:fitween/view/page/contents/contents.dart';
import 'package:fitween/view/page/contents/time_attack/camera/camera.dart';
import 'package:fitween/view/page/contents/time_attack/friend/friend.dart';
import 'package:fitween/view/page/contents/time_attack/main/main.dart';
import 'package:fitween/view/page/friend/friend.dart';
import 'package:fitween/view/page/home/calendar/calendar.dart';
import 'package:fitween/view/page/home/home.dart';
import 'package:fitween/view/page/home/ranking/ranking.dart';
import 'package:fitween/view/page/login/login.dart';
import 'package:fitween/view/page/onboarding/onboarding.dart';
import 'package:fitween/view/page/register/register.dart';
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
    '/contents/timeAttackFriend': const TimeAttackFriendPage(),
    '/contents/timeAttackReady': const TimeAttackReadyPage(),
    '/contents/timeAttackCamera': const TimeAttackCameraPage(),
    '/collection/main': const CollectionPage(),
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
