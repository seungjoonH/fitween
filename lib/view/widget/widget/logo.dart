import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';

class FAppIcon extends StatelessWidget {
  const FAppIcon({
    Key? key,
    this.size = 200.0,
    this.border = false,
  }) : super(key: key);

  static const String asset = 'assets/images/logo/app_icon.png';

  final double size;
  final bool border;

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
                  color: FTheme.white,
                  borderRadius: BorderRadius.circular(30.0.r),
                ),
              ),
              Container(
                width: size.r * .95,
                height: size.r * .95,
                decoration: BoxDecoration(
                  color: FTheme.colorA,
                  borderRadius: BorderRadius.circular(25.0.r),
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0.r),
            child: Image.asset(
              asset,
              width: size.r * (border ? .9 : 1),
              height: size.r * (border ? .9 : 1),
              fit: BoxFit.cover,
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

  static const String asset = 'assets/images/logo/fitween.png';

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(asset, width: size.w));
  }
}