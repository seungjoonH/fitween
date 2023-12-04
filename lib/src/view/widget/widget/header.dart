import 'package:fitween/global/global.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.bottomMargin,
  });

  final String? text;
  final Icon? icon;
  final VoidCallback? onPressed;
  final double? bottomMargin;

  @override
  Widget build(BuildContext context) {
    double margin = bottomMargin ?? 20.0.h;
    return Column(
      children: [
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10.0.h),
                FText(
                  text ?? '',
                  style: ThemeCont.to.commentStyle, color: ThemeCont.to.bar, bold: true,
                ),
                Divider(color: ThemeCont.to.bar, thickness: 1.0.r),
              ],
            ),
            if (icon != null)
            Positioned(
              right: .0,
              child: FIconButton(
                icon: icon!,
                iconSize: 18.0.r,
                iconColor: ThemeCont.to.comment,
                onPressed: onPressed,
              ),
            ),
          ],
        ),
        SizedBox(height: margin),
      ],
    );
  }
}
