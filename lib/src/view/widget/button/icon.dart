import 'package:fitween/global/theme.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FIconButton extends StatefulWidget {
  const FIconButton({
    super.key,
    this.icon,
    this.onPressed,
    this.size,
    this.iconColor,
    this.iconSize,
    this.backgroundColor,
  });

  final Icon? icon;
  final VoidCallback? onPressed;
  final double? size;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundColor;

  @override
  State<FIconButton> createState() => _FIconButtonState();
}

class _FIconButtonState extends State<FIconButton> with DarkPressable {
  @override
  double get pressedScale => .85;

  @override
  bool get isCircle => true;

  @override
  Widget buildContent(BuildContext context) {
    Color iconColorAlt = widget.iconColor ?? FTheme.text;
    double size = widget.size ?? 60.0.r;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
      ),
      child: Icon(
        widget.icon?.icon,
        size: widget.iconSize,
        color: iconColorAlt,
      ),
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}
