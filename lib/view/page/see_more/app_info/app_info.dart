import 'package:fitween/global/theme.dart';
import 'package:fitween/main.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/report.dart';
import 'package:fitween/presenter/page/see_more/app_info/license/license.dart';
import 'package:fitween/presenter/page/see_more/app_info/version.dart';
import 'package:fitween/presenter/page/see_more/app_info/web_view.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(title: Lang.tr('info.').capitalize!),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0.w,
          vertical: 28.0.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FTextButton(
              onPressed: WebViewP.toFitween,
              stretch: true,
              alignment: MainAxisAlignment.start,
              child: FTextsT(
                Lang.tr('fw.what'),
                textColor: FTheme.grey,
                style: textTheme(context).titleSmall,
                highlightStyles: [
                  textTheme(context).titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: FTheme.colorA,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              text: Lang.tr('fw.oss-lic'),
              onPressed: LicenseP.toLicense,
              stretch: true,
              alignment: MainAxisAlignment.start,
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              text: Lang.tr('fw.trm-srv'),
              onPressed: WebViewP.toTerm,
              stretch: true,
              alignment: MainAxisAlignment.start,
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              text: Lang.tr('fw.pri-pol'),
              onPressed: WebViewP.toPrivacyPolicy,
              stretch: true,
              alignment: MainAxisAlignment.start,
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              text: Lang.tr('fw.bug-rep.'),
              onPressed: ReportP.toReport,
              stretch: true,
              alignment: MainAxisAlignment.start,
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              onPressed: VersionP.toVersion,
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FText(Lang.tr('fw.version.'), color: FTheme.grey),
                    FText(version, style: textTheme(context).labelLarge, color: FTheme.lightGrey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              onPressed: WebViewP.toSupport,
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FText(Lang.tr('fw.support'), color: FTheme.grey),
                    FText('fitween.corp@gmail.com', style: textTheme(context).labelLarge, color: FTheme.lightGrey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
