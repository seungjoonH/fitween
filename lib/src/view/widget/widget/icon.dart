import 'package:basic_utils/basic_utils.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum FIcons {
  home,
  friend,
  contents,
  seeMore,
  ///
  homeHouse,
  pencil,
  star,
  swords,
  visibility;

  static String filePath = 'assets/image/icon/';
  String get fileName => '${name.toSnakeCase}.svg';
  String assetPath(bool selected) {
    String theme = ThemeCont.to.isLightMode ? 'light' : 'dark';
    if (!selected) return '${filePath}unselected/$fileName';
    return '${filePath}selected/$theme/$fileName';
  }
  String get label => ['Home', 'Friends', 'Challenge', 'See More'][index];
}

class FIcon extends StatelessWidget {
  const FIcon(this.icons, {
    Key? key,
    this.selected = false,
    this.size = 36.0,
    this.hasNotification = false,
  }) : super(key: key);

  final FIcons icons;
  final bool selected;
  final double size;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        if (hasNotification)
        Container(
          width: 8.0.r, height: 8.0.r,
          decoration: const BoxDecoration(
            color: ThemeCont.error,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: size.r,
          height: size.r,
          child: SvgPicture.asset(
            icons.assetPath(selected),
          ),
        ),
      ],
    );
  }
}

