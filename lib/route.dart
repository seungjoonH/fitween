/* 라우트 관련 */
import 'package:fitween/view/page/calendar/main/main.dart';
import 'package:fitween/view/page/challenge/detail/detail.dart';
import 'package:fitween/view/page/contents/contents.dart';
import 'package:fitween/view/page/contents/party/party.dart';
import 'package:fitween/view/page/contents/time_attack/camera/camera.dart';
import 'package:fitween/view/page/contents/time_attack/friend/friend.dart';
import 'package:fitween/view/page/contents/time_attack/main/main.dart';
import 'package:fitween/view/page/friend/friend.dart';
import 'package:fitween/view/page/home/home.dart';
import 'package:fitween/view/page/login/login.dart';
import 'package:fitween/view/page/onboarding/onboarding.dart';
import 'package:fitween/view/page/ranking/ranking.dart';
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
        '/home': const HomePage(),
        '/friend': const FriendPage(),
        '/calendar': const CalendarPage(),
        '/ranking': const RankingPage(),
        '/register': const RegisterPage(),
        '/login': const LoginPage(),
        '/onboarding': const OnboardingPage(),
        '/contents': const ContentsPage(),
        '/contents/challengeDetail': const ChallengeDetailPage(),
        '/contents/party': const PartyPage(),
        '/contents/timeAttackFriend': const TimeAttackFriendPage(),
        '/contents/timeAttackReady': const TimeAttackReadyPage(),
        '/contents/timeAttackCamera': const TimeAttackCameraPage(),
      };

  // 겟페이지 리스트
  static List<GetPage> get getPages => pages.entries.map((page) {
    return GetPage(
      name: page.key,
      page: () => page.value,
      transition: transition,
      transitionDuration: page.key == '/challenge/detail'
          ? const Duration(milliseconds: 500)
          : duration,
    );
  }).toList();
}
