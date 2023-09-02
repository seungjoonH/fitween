import 'dart:math';

import 'package:fitween/src/controller/loading.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FCircularPercentIndicator extends StatelessWidget {
  const FCircularPercentIndicator({
    Key? key,
    required this.percent,
    required this.color,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.radius = 55.0,
    this.lineWidth = 16.0,
    this.centerText = '',
    this.onAnimationEnd,
    this.visible = true,
    this.duration = 1000,
    this.animation = true,
  }) : super(key: key);

  final double percent;
  final Color color;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double radius;
  final double lineWidth;
  final String centerText;
  final VoidCallback? onAnimationEnd;
  final bool visible;
  final int duration;
  final bool animation;

  @override
  Widget build(BuildContext context) {
    Color textColorAlt = textColor ?? FTheme.text;
    Color borderColorAlt = borderColor ?? FTheme.text;
    Color backgroundColorAlt = backgroundColor ?? FTheme.background;

    final border = Border.all(
      color: borderColorAlt,
      width: 1.5,
    );

    if (!visible) return Container();
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: border,
            shape: BoxShape.circle,
          ),
          child: CircularPercentIndicator(
            radius: radius.r,
            lineWidth: lineWidth.r,
            percent: percent,
            backgroundColor: backgroundColorAlt,
            progressColor: color,
            animation: animation,
            animationDuration: duration,
            onAnimationEnd: onAnimationEnd,
            curve: Curves.easeInOut,
            center: FText(
              centerText,
              color: textColorAlt,
              style: FTheme.titleLarge,
              maxLines: 2,
              align: TextAlign.center
            ),
          ),
        ),
        Container(
          width: (radius - lineWidth).r * 2,
          height: (radius - lineWidth).r * 2,
          decoration: BoxDecoration(
            border: border,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class FCircularProgressIndicator extends StatelessWidget {
  const FCircularProgressIndicator({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoadingCont>(
      builder: (loadingP) {
        return Stack(
          alignment: Alignment.center,
          children: [
            child ?? Container(),
            if (loadingP.loading)
            const CircularProgressIndicator(color: FTheme.colorA),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class FLinearPercentIndicator extends LinearPercentIndicator {
  FLinearPercentIndicator({
    super.key,
    super.percent,
    this.centerText,
    super.backgroundColor,
    super.progressColor,
    super.curve,
    super.animation,
    super.animateFromLastPercent,
  });

  String? centerText;

  @override
  double get percent => max(super.percent, .02);

  @override
  EdgeInsets get padding => EdgeInsets.zero;

  @override
  double get lineHeight => 40.0.h;

  @override
  Radius? get barRadius => Radius.circular(6.0.r);

  @override
  int get animationDuration => 500;

  @override
  Curve get curve => Curves.easeInOut;

  @override
  Widget? get center => FText(
    centerText ?? '',
    style: FTheme.labelLarge,
    color: FTheme.text,
    bold: percent == 1.0,
  );

}
