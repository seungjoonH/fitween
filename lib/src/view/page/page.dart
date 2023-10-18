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
export 'main/see_more.dart';

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