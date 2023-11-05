import 'package:fitween/global/global.dart';
import 'package:fitween/main.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/app_info.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInfoPage extends FPage {
  const AppInfoPage({super.key});

  @override
  FPageState<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends FPageState<AppInfoPage> {
  @override
  AppInfoPageCont get cont => AppInfoPageCont.to;

  Widget _buildRightWidget(BuildContext context, AppInfoMenu menu) {
    switch (menu) {
      case AppInfoMenu.version:
        return FText(
          version,
          color: ThemeCont.to.comment,
          style: ThemeCont.to.commentStyle,
        );
      case AppInfoMenu.support:
        return FText(
          supportEmail,
          color: ThemeCont.to.comment,
          style: ThemeCont.to.commentStyle,
        );
      default: return Container();
    }
  }

  Widget _buildMenuWidget(BuildContext context, AppInfoMenu menu) {
    return DarkPressableWidget(
      onPressed: () => cont.menuPressed(menu),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
          vertical: 10.0.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FTexts(
              menu.locale,
              textColor: ThemeCont.to.outline,
              highlightStyle: ThemeCont.to.titleSmall?.copyWith(
                color: ThemeCont.to.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildRightWidget(context, menu),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: AppInfoMenu.values
          .map((menu) => _buildMenuWidget(context, menu))
          .separateH(height: 10.0.h),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }
}
