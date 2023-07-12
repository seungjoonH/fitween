import 'package:connectivity/connectivity.dart';
import 'package:fitween/main.dart';
import 'package:fitween/presenter/inspection/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/login_type.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/page/login.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';

// 로그인 페이지 관련 위젯 모음

// 로그인 버튼
class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
    required this.type,
  }) : super(key: key);

  final LoginType type;

  @override
  Widget build(BuildContext context) {
    const Map<LoginType, Color> backgroundColors = {
      LoginType.google: FTheme.white,
      LoginType.apple: FTheme.black,
    };
    const Map<LoginType, Color> textColors = {
      LoginType.google: FTheme.black,
      LoginType.apple: FTheme.white,
    };

    return FButton(
      onPressed: () async {
        if (await Inspection.load()) return;
        if (networkResult == ConnectivityResult.none) {
          LoginP.showNetworkErrorDialog();
          return;
        }
        if (!await AuthP.versionCheck()) {
          LoginP.showVersionInvalidDialog();
          return;
        }
        AuthP.fLogin(type);
      },
      border: true,
      backgroundColor: backgroundColors[type],
      child: Container(
        width: 230.0.w,
        // height: 30.0.h,
        padding: EdgeInsets.symmetric(vertical: 5.0.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/image/logo/${type.name}.svg',
              width: 23.0.r,
              height: 23.0.r,
            ),
            SizedBox(width: 10.0.w),
            FText(
              'Continue with ${toBeginningOfSentenceCase(type.name)}',
              style: textTheme(context).titleSmall,
              color: textColors[type],
            ),
          ],
        ),
      ),
    );
  }
}