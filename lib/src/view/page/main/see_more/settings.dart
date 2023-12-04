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
    BuildContext context, {required SettingsMenu menu}) {
    return DarkPressableWidget(
      onPressed: () => cont.menuPressed(menu),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
          vertical: 10.0.h,
        ),
        child: Row(
          children: [
            Icon(menu.icon, color: ThemeCont.to.outline),
            SizedBox(width: 10.0.w),
            FText(menu.locale, color: ThemeCont.to.outline),
          ],
        ),
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
          _buildMenuWidget(context, menu: menu),
        ).separateH(height: 10.0.h),
      ),
    ));
  }
}
