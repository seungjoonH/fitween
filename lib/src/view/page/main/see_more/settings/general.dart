import 'package:easy_localization/easy_localization.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/page/main/see_more/settings/general.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GeneralSettingPage extends FPage {
  const GeneralSettingPage({super.key});

  @override
  FPageState<GeneralSettingPage> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends FPageState<GeneralSettingPage> {
  @override
  GeneralSettingPageCont get cont => GeneralSettingPageCont.to;

  Widget _buildDisplaySettingWidget(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ThemeMode.values.map((mode) => ScalePressableWidget(
        onPressed: () => cont.setMode(mode),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0.r),
                boxShadow: [
                  BoxShadow(
                    color: ThemeCont.achro5.withOpacity(.1),
                    offset: Offset(2.0.r, 2.0.r),
                    blurRadius: 6.0.r,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                cont.modeAssets[mode]!,
                fit: BoxFit.cover,
                width: 70.0.r,
                height: 70.0.r,
              ),
            ),
            FText(
              mode.locale,
              style: ThemeCont.to.commentStyle,
              color: mode == cont.themeMode
                  ? ThemeCont.colorA
                  : ThemeCont.to.comment,
            ),
          ],
        ),
      )).toList(),
    ));
  }

  Widget _buildLanguageSettingWidget(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: Language.values.map((lang) => ScalePressableWidget(
        onPressed: () {
          cont.setLang(lang);
          Locale? locale = LangCont.to.getLocale
              ?? Locale(context.deviceLocale.languageCode);
          context.setLocale(locale);
          Get.updateLocale(locale);
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0.r),
                boxShadow: [
                  BoxShadow(
                    color: ThemeCont.to.textAlt.withOpacity(.1),
                    offset: Offset(2.0.r, 2.0.r),
                    blurRadius: 6.0.r,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                cont.langAssets[lang]!,
                fit: BoxFit.cover,
                width: 70.0.r,
                height: 70.0.r,
              ),
            ),
            FText(
              lang.locale,
              style: ThemeCont.to.commentStyle,
              color: lang == cont.language
                  ? ThemeCont.colorA
                  : ThemeCont.to.comment,
            ),
          ],
        ),
      )).toList(),
    ));
  }

  Widget _buildSettingWidget(BuildContext context, GeneralSettingMenu menu) {
    switch (menu) {
      case GeneralSettingMenu.display:
        return _buildDisplaySettingWidget(context);
      case GeneralSettingMenu.language:
        return _buildLanguageSettingWidget(context);
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() => FScaffold(
      backgroundColor: ThemeCont.to.background,
      appBar: FAppBar(text: cont.appBarTitle),
      body: Column(
        children: GeneralSettingMenu.values.map((menu) => Column(
          children: [
            HeaderWidget(text: menu.locale),
            _buildSettingWidget(context, menu),
          ],
        )).separateH(height: 20.0.h),
      ),
    ));
  }
}
