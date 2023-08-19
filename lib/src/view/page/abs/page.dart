import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

export '../concrete/login.dart';
export '../concrete/onboarding.dart';
export '../concrete/register.dart';
export '../concrete/goal_setting.dart';

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