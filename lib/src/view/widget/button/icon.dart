import 'package:fitween/global/theme.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FIconButton extends StatefulWidget {
  const FIconButton({
    super.key,
    this.icon,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.backgroundColor,
  });

  final Icon? icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundColor;

  @override
  State<FIconButton> createState() => _FIconButtonState();
}

class _FIconButtonState extends State<FIconButton> with DarkPressable {
  @override
  Widget buildContent(BuildContext context) {
    Color iconColorAlt = widget.iconColor ?? FTheme.text;
    radius = BorderRadius.circular(50.0.r);

    return Container(
      padding: EdgeInsets.all(20.0.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
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
