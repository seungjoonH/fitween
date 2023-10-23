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
    super.key,
    required this.percent,
    this.radius,
    this.lineWidth,
    this.backgroundColor,
    this.progressColor,
    this.animation,
    this.animationDuration,
    this.enableCenter = false,
    this.centerColor,
  });

  final double percent;
  final double? radius;
  final double? lineWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool? animation;
  final int? animationDuration;
  final bool enableCenter;
  final Color? centerColor;

  String get _centerText => enableCenter
      ? '@{${(percent * 100).round()}} %' : '';

  Color get _progressColor => progressColor ?? FTheme.colorA;

  Widget? get _center => enableCenter ? FTexts(
    _centerText,
    textColor: centerColor ?? _progressColor,
    style: FTheme.bodySmall,
    highlightStyle: FTheme.titleLarge,
  ) : null;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      percent: percent,
      radius: radius ?? 35.0.r,
      lineWidth: lineWidth ?? 8.0.r,
      backgroundColor: backgroundColor ?? FTheme.background,
      progressColor: _progressColor,
      animation: animation ?? true,
      animationDuration: animationDuration ?? 500,
      circularStrokeCap: CircularStrokeCap.round,
      center: _center,
    );
  }
}


// class FCircularPercentIndicator extends StatelessWidget {
//   const FCircularPercentIndicator({
//     Key? key,
//     required this.percent,
//     required this.color,
//     this.textColor,
//     this.borderColor,
//     this.backgroundColor,
//     this.radius = 55.0,
//     this.lineWidth = 16.0,
//     this.centerText = '',
//     this.onAnimationEnd,
//     this.visible = true,
//     this.duration = 1000,
//     this.animation = true,
//   }) : super(key: key);
//
//   final double percent;
//   final Color color;
//   final Color? textColor;
//   final Color? borderColor;
//   final Color? backgroundColor;
//   final double radius;
//   final double lineWidth;
//   final String centerText;
//   final VoidCallback? onAnimationEnd;
//   final bool visible;
//   final int duration;
//   final bool animation;
//
//   @override
//   Widget build(BuildContext context) {
//     Color textColorAlt = textColor ?? FTheme.text;
//     Color borderColorAlt = borderColor ?? FTheme.text;
//     Color backgroundColorAlt = backgroundColor ?? FTheme.background;
//
//     final border = Border.all(
//       color: borderColorAlt,
//       width: 1.5,
//     );
//
//     if (!visible) return Container();
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             border: border,
//             shape: BoxShape.circle,
//           ),
//           child: CircularPercentIndicator(
//             radius: radius.r,
//             lineWidth: lineWidth.r,
//             percent: percent,
//             backgroundColor: backgroundColorAlt,
//             progressColor: color,
//             animation: animation,
//             animationDuration: duration,
//             onAnimationEnd: onAnimationEnd,
//             curve: Curves.easeInOut,
//             center: FText(
//               centerText,
//               color: textColorAlt,
//               style: FTheme.titleLarge,
//               maxLines: 2,
//               align: TextAlign.center
//             ),
//           ),
//         ),
//         Container(
//           width: (radius - lineWidth).r * 2,
//           height: (radius - lineWidth).r * 2,
//           decoration: BoxDecoration(
//             border: border,
//             shape: BoxShape.circle,
//           ),
//         ),
//       ],
//     );
//   }
// }

class FCircularProgressIndicator extends StatelessWidget {
  const FCircularProgressIndicator({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  LoadingCont get cont => LoadingCont.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      alignment: Alignment.center,
      children: [
        child ?? Container(),
        if (cont.loading) const CircularProgressIndicator(color: FTheme.colorA),
      ],
    ));
  }
}

// ignore: must_be_immutable
class FLinearPercentIndicator extends LinearPercentIndicator {
  FLinearPercentIndicator({
    super.key,
    super.percent,
    super.center,
    this.centerText,
    this.height,
    this.radius,
    super.backgroundColor,
    super.progressColor,
    super.curve,
    super.animation,
    super.animateFromLastPercent,
  });

  String? centerText;
  final double? height;
  final double? radius;

  @override
  double get percent => max(super.percent, .02);

  @override
  EdgeInsets get padding => EdgeInsets.zero;

  @override
  double get lineHeight => height ?? 40.0.h;

  @override
  Radius? get barRadius => Radius.circular(radius ?? 6.0.r);

  @override
  int get animationDuration => 500;

  @override
  Curve get curve => Curves.easeInOut;

  bool get _completed => percent == 1.0;

  @override
  Widget? get center => super.center ?? FText(
    centerText ?? '',
    style: FTheme.labelLarge,
    color: _completed
        ? FTheme.backgroundAlt
        : FTheme.text,
    bold: _completed,
  );

}

class FOverlappedLinearPercentIndicator extends StatelessWidget {
  const FOverlappedLinearPercentIndicator({
    super.key,
    this.backPercent,
    this.forePercent,
    this.height,
    this.radius,
    this.backgroundColor,
    this.backProgressColor,
    this.foreProgressColor,
    this.curve,
    this.animation,
    this.animateFromLastPercent,
  });

  final double? backPercent;
  final double? forePercent;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final Color? backProgressColor;
  final Color? foreProgressColor;
  final Curve? curve;
  final bool? animation;
  final bool? animateFromLastPercent;

  double get _backPercent => max(min(backPercent ?? .0, 1.0), .0);
  double get _forePercent => max(min(forePercent ?? .0, 1.0), .0);

  Curve get _curve => curve ?? Curves.easeInOut;

  bool get _animation => animation ?? false;
  bool get _animateFromLastPercent => animateFromLastPercent ?? false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        FLinearPercentIndicator(
          percent: _backPercent,
          height: height,
          radius: radius,
          backgroundColor: backgroundColor,
          progressColor: backProgressColor,
          curve: _curve,
          animation: _animation,
          animateFromLastPercent: _animateFromLastPercent,
        ),
        FLinearPercentIndicator(
          percent: _forePercent,
          height: height,
          radius: radius,
          backgroundColor: backgroundColor,
          progressColor: foreProgressColor,
          curve: _curve,
          animation: _animation,
          animateFromLastPercent: _animateFromLastPercent,
        ),
      ],
    );
  }
}