import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/text.dart';

class PLogo extends StatelessWidget {
  const PLogo({Key? key}) : super(key: key);

  static const String asset = 'assets/image/logo/pistachio.svg';

  @override
  Widget build(BuildContext context) {
    // return Center(child: SvgPicture.asset(asset));
    return FText('Fitween',
      color: FTheme.white,
      border: true,
      borderWidth: 1.5,
      style: TextStyle(fontSize: 75.0.sp),
    );
  }
}