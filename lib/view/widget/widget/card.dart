import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/gestures.dart';
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
    this.color = FTheme.white,
    this.rounded = false,
    this.borderType = BorderType.all,
    this.borderColor = FTheme.black,
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

class FCard extends StatefulWidget {
  const FCard({
    Key? key,
    this.title,
    this.activateSeeMore = false,
    required this.child,
    this.backgroundColor = FTheme.white,
    this.onPressed,
  }) : super(key: key);

  final String? title;
  final bool activateSeeMore;
  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  @override
  State<FCard> createState() => _FCardState();
}

class _FCardState extends State<FCard> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;

  double scale = 1.0;
  Duration duration = const Duration(milliseconds: 100);

  @override
  void initState() {
    onTapDown = widget.onPressed == null ? null : (_) {
      setState(() => scale = .9);
    };
    onTapUp = widget.onPressed == null ? null : (_) async {
      widget.onPressed!();
      await Future.delayed(duration, () {
        setState(() => scale = 1.0);
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(12.0);

    return AnimatedScale(
      scale: scale,
      duration: duration,
      child: GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: Material(
          borderRadius: radius,
          color: widget.backgroundColor,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: radius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FText(widget.title!, style: textTheme.titleLarge, color: FTheme.darkGrey),
                        if (widget.activateSeeMore)
                          const Icon(Icons.arrow_forward_ios, color: FTheme.lightGrey),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
