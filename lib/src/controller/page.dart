import 'package:fitween/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'page/main/home/calendar.dart';
export 'page/main/home/ranking.dart';
export 'page/main/home.dart';
export 'page/main/friend/search.dart';
export 'page/main/friend.dart';
export 'page/main/contents/adventure/level_detail.dart';
export 'page/main/contents/adventure.dart';
export 'page/main/contents/challenge/party/create.dart';
export 'page/main/contents/challenge/party/member_setting.dart';
export 'page/main/contents/challenge/party/search.dart';
export 'page/main/contents/challenge/party/applicants.dart';
export 'page/main/contents/challenge/party/history.dart';
export 'page/main/contents/challenge/party.dart';
export 'page/main/contents/challenge/detail.dart';
export 'page/main/contents/challenge.dart';
export 'page/main/contents/camera/camera.dart';
export 'page/main/contents/weight/guide.dart';
export 'page/main/contents/weight/camera.dart';
export 'page/main/contents/weight/complete.dart';
export 'page/main/contents/weight.dart';
export 'page/main/contents/battle.dart';
export 'page/main/contents.dart';
export 'page/main/see_more/notification.dart';
export 'page/main/see_more/inventory.dart';
export 'page/main/see_more/badge.dart';
export 'page/main/see_more/settings/general.dart';
export 'page/main/see_more/settings/app_info.dart';
export 'page/main/see_more/settings/app_info/terms_in_use.dart';
export 'page/main/see_more/settings/app_info/privacy_policy.dart';
export 'page/main/see_more/settings/app_info/support.dart';
export 'page/main/see_more/settings/app_info/version.dart';
export 'page/main/see_more/settings/app_info/patch_note.dart';
export 'page/main/see_more/settings/app_info/oss_licenses.dart';
export 'page/main/see_more/settings/app_info/license_detail.dart';
export 'page/main/see_more/settings/app_info/fitween.dart';
export 'page/main/see_more/settings/app_info/report/detail.dart';
export 'page/main/see_more/settings/app_info/report/edit.dart';
export 'page/main/see_more/settings/app_info/report.dart';
export 'page/main/see_more/settings/account.dart';
export 'page/main/see_more/settings/my_info.dart';
export 'page/main/see_more/settings.dart';
export 'page/main/see_more.dart';
export 'page/main.dart';
export 'page/fpoint/history.dart';
export 'page/fpoint.dart';
export 'page/carousel.dart';
export 'page/goal_setting.dart';
export 'page/login.dart';
export 'page/onboarding.dart';
export 'page/register.dart';

abstract class PageCont extends GetxController {
  static final List<BuildContext> _contexts = [];
  static List<BuildContext> get contexts => _contexts;
  static set context(BuildContext cont) {
    if (_contexts.contains(cont)) return;
    _contexts.add(cont);
  }
  static BuildContext get context => _contexts.last;
  static removeContext(context) {
    return _contexts.remove(context);
  }

  static late MediaQueryData mediaQuery;
  static Size get size => mediaQuery.size;
  static Orientation get orientation => mediaQuery.orientation;

  static bool get isPortrait => orientation == Orientation.portrait;
  static bool get isLandscape => orientation == Orientation.landscape;

  void initState({bool reload = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      return reload ? await onRefresh() : await init();
    });
  }

  String get loadKey;

  Future init() async {
    if (LoadingCont.start(loadKey, 180)) {
      await load();
      LoadingCont.end();
    }
    afterRoute();
  }

  Future onRefresh() async {
    if (LoadingCont.start()) {
      await load();
      LoadingCont.end();
    }
    afterRoute();
  }

  Future load();
  Future afterRoute() async {}
}