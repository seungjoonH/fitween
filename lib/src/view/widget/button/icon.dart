import 'package:fitween/src/controller/theme.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

class FIconButton extends StatefulWidget {
  const FIconButton({
    super.key,
    this.icon,
    this.child,
    this.onPressed,
    this.size,
    this.iconColor,
    this.iconSize,
    this.backgroundColor,
    this.notifications,
  }) : assert(icon == null || child == null);

  final Icon? icon;
  final Widget? child;
  final VoidCallback? onPressed;
  final double? size;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundColor;
  final int? notifications;

  @override
  State<FIconButton> createState() => _FIconButtonState();
}

class _FIconButtonState extends State<FIconButton> with DarkPressable {
  @override
  double get pressedScale => .85;

  @override
  bool get isCircle => true;

  String? get notifications {
    if (widget.notifications == null) return null;
    if (widget.notifications == 0) return null;
    int value = widget.notifications!;
    if (value > 99) return '99+';
    return ' $value ';
  }

  Color get _iconColorAlt => widget.iconColor ?? ThemeCont.to.text;

  Widget get _child => widget.child ?? Icon(
    widget.icon?.icon,
    size: widget.iconSize,
    color: _iconColorAlt,
  );

  @override
  Widget buildContent(BuildContext context) {
    double size = widget.size ?? 50.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: isCircle
                ? BoxShape.circle
                : BoxShape.rectangle,
            color: widget.backgroundColor,
          ),
          child: _child,
        ),
        if (notifications != null)
        Positioned(
          top: 5.0, right: 5.0,
          child: FTextTag(
            notifications!,
            textColor: ThemeCont.achro95,
            backgroundColor: ThemeCont.error,
          ),
        ),
      ],
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}
