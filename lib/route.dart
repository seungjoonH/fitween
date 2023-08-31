import 'package:fitween/global/global.dart';
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
    '/friend': const FriendPage(),
    '/contents': const ContentsPage(),
    '/see-more': const SeeMorePage(),
  };

  static List<GetPage> get getPages => pages.entries.map((page) {
    return GetPage(
      name: page.key,
      page: () => page.value,
      transition: Transition.fadeIn,
      transitionDuration: 100.ms,
    );
  }).toList();

  static const _offAllRoutes = ['/', '/home', '/contents', '/see-more'];

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

  static void toLogin() => Get.offAllNamed('/');
  static void toOnboarding() => Get.toNamed('/onboarding');
  static void toRegister() => Get.toNamed('/register');
  static void toGoalSetting() => Get.toNamed('/goal-setting');
  static void toHome() => Get.offAllNamed('/home');
  static void toCalendar() => Get.toNamed('/home/calendar');
  static void toFriend() => Get.offAllNamed('/friend');
  static void toContents() => Get.offAllNamed('/contents');
  static void toSeeMore() => Get.offAllNamed('/see-more');
}
