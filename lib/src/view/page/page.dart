import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

export 'login.dart';
export 'onboarding.dart';
export 'register.dart';
export 'goal_setting.dart';
export 'main/home/calendar.dart';
export 'main/home/ranking.dart';
export 'main/home.dart';
export 'main/friend/search.dart';
export 'main/friend.dart';
export 'main/contents/adventure/level_detail.dart';
export 'main/contents/adventure.dart';
export 'main/contents/challenge/party/create.dart';
export 'main/contents/challenge/party/member_setting.dart';
export 'main/contents/challenge/party/search.dart';
export 'main/contents/challenge/party/applicants.dart';
export 'main/contents/challenge/party/history.dart';
export 'main/contents/challenge/party.dart';
export 'main/contents/challenge/detail.dart';
export 'main/contents/challenge.dart';
export 'main/contents/weight.dart';
export 'main/contents/battle.dart';
export 'main/contents.dart';
export 'main/see_more/notification.dart';
export 'main/see_more/settings/general.dart';
export 'main/see_more/settings/app_info/terms_in_use.dart';
export 'main/see_more/settings/app_info/privacy_policy.dart';
export 'main/see_more/settings/app_info/support.dart';
export 'main/see_more/settings/app_info/version.dart';
export 'main/see_more/settings/app_info/patch_note.dart';
export 'main/see_more/settings/app_info/oss_licenses.dart';
export 'main/see_more/settings/app_info/license_detail.dart';
export 'main/see_more/settings/app_info/fitween.dart';
export 'main/see_more/settings/app_info/report/detail.dart';
export 'main/see_more/settings/app_info/report/edit.dart';
export 'main/see_more/settings/app_info/report.dart';
export 'main/see_more/settings/app_info.dart';
export 'main/see_more/settings.dart';
export 'main/see_more.dart';
export 'fpoint/history.dart';
export 'fpoint.dart';

abstract class FPage extends FWidget {
  const FPage({super.key});
}

abstract class FPageState<T extends FPage> extends FWidgetState<T> {
  PageCont get cont;

  bool get unconditionallyRefresh => false;

  @override
  void initState() {
    super.initState();
    cont.initState(reload: unconditionallyRefresh);
  }

  Widget buildPage(BuildContext context);

  @override
  Widget buildWidget(BuildContext context) {
    return buildPage(context);
  }
}