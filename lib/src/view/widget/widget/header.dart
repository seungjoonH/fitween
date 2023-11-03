import 'package:fitween/global/global.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FText(text ?? '', style: ThemeCont.to.commentStyle, color: ThemeCont.to.bar, bold: true),
        Divider(color: ThemeCont.to.bar, thickness: 1.0.r),
        SizedBox(height: 20.0.h),
      ],
    );
  }
}
