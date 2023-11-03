import 'package:fitween/src/controller/page/main/see_more/settings/app_info.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

class AppInfoPage extends FPage {
  const AppInfoPage({super.key});

  @override
  FPageState<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends FPageState<AppInfoPage> {
  @override
  AppInfoPageCont get cont => AppInfoPageCont.to;

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold();
  }
}
