import 'package:fitween/global/theme.dart';
import 'package:fitween/main.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/report.dart';
import 'package:fitween/presenter/page/see_more/app_info/license/license.dart';
import 'package:fitween/presenter/page/see_more/app_info/version.dart';
import 'package:fitween/presenter/page/see_more/app_info/web_view.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FAppBar(title: '정보'),
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
              child: Row(
                children: [
                  FText('피트윈', bold: true, color: FTheme.darkGrey),
                  FText('이 뭔가요?', color: FTheme.grey),
                ],
              ),
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              text: '오픈소스 라이선스',
              onPressed: LicenseP.toLicense,
              stretch: true,
              alignment: MainAxisAlignment.start,
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              text: '이용약관',
              onPressed: WebViewP.toTerm,
              stretch: true,
              alignment: MainAxisAlignment.start,
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              text: '개인정보 처리방침',
              onPressed: WebViewP.toPrivacyPolicy,
              stretch: true,
              alignment: MainAxisAlignment.start,
            ),
            SizedBox(height: 10.0.h),
            FTextButton(
              text: '오류 제보 / 개선 요청',
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
                    FText('버전', color: FTheme.grey),
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
                    FText('고객지원', color: FTheme.grey),
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
