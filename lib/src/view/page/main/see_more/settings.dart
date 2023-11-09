import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsPage extends FPage {
  const SettingsPage({super.key});

  @override
  FPageState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends FPageState<SettingsPage> {

  @override
  SettingsPageCont get cont => SettingsPageCont.to;

  Widget _buildMenuWidget(
    BuildContext context, {
    required String title,
    VoidCallback? onPressed,
  }) {
    return DarkPressableWidget(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
          vertical: 10.0.h,
        ),
        child: FText(title, color: ThemeCont.to.outline),
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() => FScaffold(
      backgroundColor: ThemeCont.to.background,
      appBar: FAppBar(text: cont.appBarTitle),
      body: Column(
        children: SettingsMenu.values.map((menu) =>
          _buildMenuWidget(
            context,
            title: menu.locale,
            onPressed: () => cont.menuPressed(menu),
          ),
        ).separateH(height: 10.0.h),
      ),
    ));
  }
}
