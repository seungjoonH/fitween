import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/src/controller/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FAppIcon extends StatelessWidget {
  const FAppIcon({
    Key? key,
    this.size = 210.0,
    this.border = false,
    this.backgroundColor,
  }) : super(key: key);

  static const String asset = 'assets/image/logo/app_icon.svg';

  final double size;
  final bool border;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (border)
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size.r,
                height: size.r,
                decoration: BoxDecoration(
                  color: ThemeCont.to.backgroundAlt,
                  borderRadius: BorderRadius.circular((size / 7).r),
                ),
              ),
              Container(
                width: size.r * .95,
                height: size.r * .95,
                decoration: BoxDecoration(
                  color: ThemeCont.colorA,
                  borderRadius: BorderRadius.circular((size * .95 / 7).r),
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular((size * .75 / 7).r),
            child: Container(
              color: backgroundColor,
              child: SvgPicture.asset(
                asset,
                width: size.r * (border ? .9 : 1),
                height: size.r * (border ? .9 : 1),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class FLogo extends StatelessWidget {
  const FLogo({
    Key? key,
    this.size = 250.0,
  }) : super(key: key);

  static const String asset = 'assets/image/logo/fitween.png';

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(asset, width: size.w));
  }
}