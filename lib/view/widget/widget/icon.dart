import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PIcons {
  homeHouse,
  pencil,
  star;

  static String filePath = 'assets/image/icon/';
  String get fileName =>
      '${StringUtils.camelCaseToLowerUnderscore(name)}.svg';
  String assetPath(bool selected) =>
      '$filePath${selected ? '' : 'un'}selected/$fileName';
}

class PIcon extends StatelessWidget {
  const PIcon(this.icons, {
    Key? key,
    this.selected = false,
    this.size = 36.0,
  }) : super(key: key);

  final PIcons icons;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.r,
      height: size.r,
      child: SvgPicture.asset(
        icons.assetPath(selected),
      ),
    );
  }
}

