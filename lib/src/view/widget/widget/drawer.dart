import 'package:fitween/src/controller/theme.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FDrawer extends Drawer {
  const FDrawer({
    super.key,
    super.child,
  });

  @override
  double? get width => 200.0.w;

  @override
  Widget? get child => Column(
    children: [
      Container(
        height: 200.0.h,
        color: ThemeCont.colorA,
        alignment: Alignment.center,
        child: const FAppIcon(size: 80.0),
      ),
      if (super.child != null)
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: super.child!,
      ),
    ],
  );
}