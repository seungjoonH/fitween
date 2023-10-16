import 'package:fitween/global/theme.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
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
    Color backgroundColorAlt = backgroundColor ?? FTheme.unselected;
    Widget childAlt = child ?? FText('', style: FTheme.labelMedium);

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

  Color get textColorAlt => textColor ?? FTheme.backgroundAlt;

  @override
  Widget get child {

    return FText(text,
      style: FTheme.labelMedium,
      color: textColorAlt,
    );
  }

}

class MeTag extends StatelessWidget {
  const MeTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FTextTag('ME',
      textColor: FTheme.backgroundAlt,
      backgroundColor: FTheme.text,
    );
  }
}

class FTypeTag extends StatelessWidget {
  const FTypeTag({
    super.key,
    required this.type,
  });

  final FType type;

  @override
  Widget build(BuildContext context) {
    return FTextTag(
      type.locale.capitalize!,
      textColor: FTheme.achro95,
      backgroundColor: type.color,
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
          ? FTheme.achro5
          : FTheme.achro95,
      backgroundColor: difficulty.color,
    );
  }
}