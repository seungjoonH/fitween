import 'package:fitween/global/global.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FRoute {
  static Map<String, Widget> get pages => {
    '/': const LoginPage(),
    '/onboarding': const OnboardingPage(),
    '/register': const RegisterPage(),
    '/goal-setting': const GoalSettingPage(),
    '/home': const HomePage(),
    '/home/calendar': const CalendarPage(),
    '/home/ranking': const RankingPage(),
    '/friend': const FriendPage(),
    '/friend/search': const FriendSearchPage(),
    '/contents': const ContentsPage(),
    '/contents/adventure': const AdventurePage(),
    '/contents/adventure/level-detail': const LevelDetailPage(),
    '/contents/challenge/party': const PartyPage(),
    '/contents/challenge/party/create': const PartyCreatePage(),
    '/contents/challenge/party/member-setting': const PartyMemberSettingPage(),
    '/contents/challenge/party/search': const PartySearchPage(),
    '/contents/challenge/party/applicants': const PartyApplicantsPage(),
    '/contents/challenge/party/history': const PartyHistoryPage(),
    '/contents/challenge/detail': const ChallengeDetailPage(),
    '/contents/challenge': const ChallengePage(),
    '/contents/weight': const WeightPage(),
    '/contents/battle': const BattlePage(),
    '/see-more': const SeeMorePage(),
    '/see-more/notification': const NotificationPage(),
    '/fpoint': const FPointPage(),
    '/fpoint/history': const FPointHistoryPage(),
  };

  static List<GetPage> get getPages => pages.entries.map((page) {
    return GetPage(
      name: page.key,
      page: () => page.value,
      transition: Transition.fadeIn,
      transitionDuration: getTransitionDuration(page.key),
    );
  }).toList();

  static const _offAllRoutes = ['/', '/home', '/friend', '/contents', '/see-more'];

  static String get currentPage => Get.currentRoute;
  static String? get previousPage {
    String current = Get.currentRoute;
    List<String> sublist = _offAllRoutes.sublist(1, _offAllRoutes.length);

    bool contains = _offAllRoutes.contains(current);
    contains |= sublist.any((r) => current.contains(r));
    if (!contains) return Get.previousRoute;

    List<String> routes = Get.currentRoute.split('/');
    String previous = routes.sublist(0, routes.length - 1).join('/');
    return previous.isNotEmpty ? previous : null;
  }

  static Duration getTransitionDuration(String key) {
    if (key.contains('detail')) return 500.ms;
    return 100.ms;
  }

  static void toLogin() => Get.offAllNamed('/');
  static void toOnboarding() => Get.toNamed('/onboarding');
  static void toRegister() => Get.toNamed('/register');
  static void toGoalSetting() => Get.toNamed('/goal-setting');
  static void toHome() => Get.offAllNamed('/home');
  static void toCalendar() => Get.toNamed('/home/calendar');
  static void toRanking() => Get.toNamed('/home/ranking');
  static void toFriend({bool reload = false}) => Get.offAllNamed('/friend', arguments: reload);
  static void toFriendSearch() => Get.toNamed('/friend/search');
  static void toContents() => Get.offAllNamed('/contents');
  static void toAdventure() => Get.toNamed('/contents/adventure');
  static void toLevelDetail() => Get.toNamed('/contents/adventure/level-detail');
  static void toParty({Party? party}) => Get.toNamed('/contents/challenge/party', arguments: party);
  static void toPartyCreate({Challenge? challenge}) => Get.toNamed('/contents/challenge/party/create', arguments: challenge);
  static void toPartyMemberSetting({Party? party}) => Get.toNamed('/contents/challenge/party/member-setting', arguments: party);
  static void toPartySearch({String keyword = ''}) => Get.toNamed('/contents/challenge/party/search', arguments: keyword);
  static void toPartyApplicants({Party? party}) => Get.toNamed('/contents/challenge/party/applicants', arguments: party);
  static void toPartyHistory() => Get.toNamed('/contents/challenge/party/history');
  static void toChallengeDetail({Challenge? challenge}) => Get.toNamed('/contents/challenge/detail', arguments: challenge);
  static void toChallenge() => Get.toNamed('/contents/challenge');
  static void toWeight() => Get.toNamed('/contents/weight');
  static void toBattle() => Get.toNamed('/contents/battle');
  static void toSeeMore() => Get.offAllNamed('/see-more');
  static void toNotification() => Get.toNamed('/see-more/notification');
  static void toFPoint() => Get.toNamed('/fpoint');
  static void toFPointHistory() => Get.toNamed('/fpoint/history');
}
