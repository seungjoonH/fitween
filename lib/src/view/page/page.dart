import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'login.dart';
export 'onboarding.dart';
export 'register.dart';
export 'goal_setting.dart';
export 'main/home.dart';
export 'main/friend.dart';
export 'main/contents.dart';
export 'main/see_more.dart';
export 'main/home/calendar.dart';

abstract class FPage extends FWidget {
  const FPage({super.key});
}

abstract class FPageState<T extends FPage> extends FWidgetState<T> {
  GetxController get cont;

  Widget buildPage(BuildContext context);

  @override
  Widget buildWidget(BuildContext context) {
    return buildPage(context);
  }
}