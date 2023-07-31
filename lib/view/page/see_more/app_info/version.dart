import 'package:fitween/global/theme.dart';
import 'package:fitween/main.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/page/see_more/app_info/version.dart';
import 'package:fitween/presenter/page/see_more/app_info/web_view.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/logo.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VersionPage extends StatelessWidget {
  const VersionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FTheme.colorA,
      appBar: const FAppBar(iconColor: FTheme.white),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 28.0.w, vertical: 28.0.h,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FAppIcon(border: true),
              SizedBox(height: 10.0.h),
              FText(
                'Fitween',
                color: FTheme.white,
                style: textTheme(context).titleLarge,
                bold: true,
              ),
              SizedBox(height: 10.0.h),
              const FTag(
                version,
                backgroundColor: FTheme.white,
                textColor: FTheme.darkGrey,
              ),
              SizedBox(height: 10.0.h),
              FText(
                VersionP.message,
                color: FTheme.white,
                style: textTheme(context).labelLarge,
                maxLines: 3,
              ),
              SizedBox(height: 40.0.h),
              FButton(
                text: Lang.tr('fw.rel-note.show'),
                backgroundColor: FTheme.grey,
                onPressed: WebViewP.toPatchNote,
              ),
            ],
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
