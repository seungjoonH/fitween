import 'package:fitween/src/controller/theme.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FTag extends StatelessWidget {
  const FTag({
    super.key,
    this.backgroundColor,
    this.child,
  });

  final Color? backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Color backgroundColorAlt = backgroundColor ?? ThemeCont.to.unselected;
    Widget childAlt = child ?? FText('', style: ThemeCont.to.labelMedium);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.0.r, vertical: 2.0.r,
      ),
      decoration: BoxDecoration(
        color: backgroundColorAlt,
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: childAlt,
    );
  }
}


class FTextTag extends FTag {
  const FTextTag(this.text, {
    super.key,
    this.textColor,
    super.backgroundColor,
  });

  final String text;
  final Color? textColor;

  Color get textColorAlt => textColor ?? ThemeCont.to.backgroundAlt;

  @override
  Widget get child {

    return FText(text,
      style: ThemeCont.to.labelMedium,
      color: textColorAlt,
    );
  }

}

class MeTag extends StatelessWidget {
  const MeTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FTextTag('ME',
      textColor: ThemeCont.to.backgroundAlt,
      backgroundColor: ThemeCont.to.text,
    );
  }
}

class FTypeTag extends StatelessWidget {
  const FTypeTag({
    super.key,
    required this.type,
    this.color,
  });

  final FType type;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FTextTag(
      type.localeShort,
      textColor: ThemeCont.achro95,
      backgroundColor: color ?? type.color,
    );
  }
}


class DifficultyTag extends StatelessWidget {
  const DifficultyTag({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    bool normal = difficulty == Difficulty.normal;

    return FTextTag(
      difficulty.locale.capitalize!,
      textColor: normal
          ? ThemeCont.achro5
          : ThemeCont.achro95,
      backgroundColor: difficulty.color,
    );
  }
}

class FLoginTypeTag extends StatelessWidget {
  const FLoginTypeTag({
    super.key,
    required this.type,
  });

  final LoginType type;

  @override
  Widget build(BuildContext context) {
    return FTextTag(
      type.name.capitalize!,
      textColor: ThemeCont.achro95,
      backgroundColor: type.color,
    );
  }
}
