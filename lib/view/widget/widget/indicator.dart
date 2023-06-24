import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/text.dart';

class PCircularPercentIndicator extends StatelessWidget {
  const PCircularPercentIndicator({
    Key? key,
    required this.percent,
    required this.color,
    this.textColor = FTheme.black,
    this.borderColor = FTheme.black,
    this.backgroundColor = FTheme.background,
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
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double lineWidth;
  final String centerText;
  final VoidCallback? onAnimationEnd;
  final bool visible;
  final int duration;
  final bool animation;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: borderColor,
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
            backgroundColor: backgroundColor,
            progressColor: color,
            animation: animation,
            animationDuration: duration,
            onAnimationEnd: onAnimationEnd,
            curve: Curves.easeInOut,
            center: FText(centerText,
              color: textColor,
              style: textTheme(context).titleLarge,
              borderWidth: 1.0,
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

class PCircularProgressIndicator extends StatelessWidget {
  const PCircularProgressIndicator({
    Key? key,
    required this.visible,
  }) : super(key: key);

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return visible ? Stack(
      alignment: Alignment.center,
      children: const [
        CircularProgressIndicator(
          color: FTheme.colorA,
        ),
        // Container(
        //   color: FTheme.black.withOpacity(.3),
        // ),
      ],
    ) : Container();
  }
}
