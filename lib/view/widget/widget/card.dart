import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/border_type.dart';

class PCard extends StatelessWidget {
  PCard({
    Key? key,
    required this.child,
    EdgeInsets? padding,
    this.onPressed,
    this.color = PTheme.white,
    this.rounded = false,
    this.borderType = BorderType.all,
    this.borderColor = PTheme.black,
    this.borderWidth = 1.5,
  }) : padding = padding ?? EdgeInsets.all(20.0.r), super(key: key);

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;
  final Color color;
  final bool rounded;
  final BorderType borderType;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    BorderRadius? radius = rounded
        ? BorderRadius.circular(20.0) : null;

    bool leftBorder = [BorderType.left, BorderType.vertical, BorderType.all].contains(borderType);
    bool topBorder = [BorderType.top, BorderType.horizontal, BorderType.all].contains(borderType);
    bool rightBorder = [BorderType.right, BorderType.vertical, BorderType.all].contains(borderType);
    bool bottomBorder = [BorderType.bottom, BorderType.horizontal, BorderType.all].contains(borderType);

    return Material(
      color: color,
      borderRadius: radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            border: Border(
              left: leftBorder ? BorderSide(
                color: borderColor,
                width: borderWidth.h,
              ) : BorderSide.none,
              top: topBorder ? BorderSide(
                color: borderColor,
                width: borderWidth.h,
              ) : BorderSide.none,
              right: rightBorder ? BorderSide(
                color: borderColor,
                width: borderWidth.h,
              ) : BorderSide.none,
              bottom: bottomBorder ? BorderSide(
                color: borderColor,
                width: borderWidth.h,
              ) : BorderSide.none,

            ),
            borderRadius: radius,
          ),
          child: child,
        ),
      ),
    );
  }
}
