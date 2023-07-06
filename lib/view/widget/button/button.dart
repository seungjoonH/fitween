/* 커스텀 버튼 위젯 */

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/icon.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:pausable_timer/pausable_timer.dart';

class FButton extends StatefulWidget {
  FButton({
    Key? key,
    this.text,
    this.child,
    this.onPressed,
    this.fill = true,
    EdgeInsets? padding,
    this.constraints,
    Color? backgroundColor,
    Color? textColor,
    this.stretch = false,
    this.multiple = false,
    this.border = false,
    this.motion = false,
    this.height,
  }) : assert(text == null || child == null),
    padding = padding ?? EdgeInsets.symmetric(
      horizontal: 20.0.w, vertical: 10.0.h,
    ),
    backgroundColor = backgroundColor ?? FTheme.darkGrey,
    textColor = textColor ?? (fill ? FTheme.white : FTheme.black),
    super(key: key);

  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool fill;
  final EdgeInsets padding;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final Color? textColor;
  final bool stretch;
  final bool multiple;
  final bool border;
  final bool motion;
  final double? height;

  @override
  State<FButton> createState() => _FButtonState();
}

class _FButtonState extends State<FButton> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;
  VoidCallback? onTapCancel;

  double scale = 1.0;
  Duration duration = const Duration(milliseconds: 100);
  PausableTimer? timer;

  @override
  void initState() {
    onTapDown = widget.onPressed == null ? null : (_) {
      timer?.pause();
      setState(() => scale = .9);
    };
    onTapUp = widget.onPressed == null ? null : (_) async {
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() => scale = 1.0);
      });
      widget.onPressed!();
    };
    onTapCancel = () {
      timer?.start();
      setState(() => scale = 1.0);
    };
    if (!widget.motion) return;
    timer = PausableTimer(const Duration(milliseconds: 600), () async {
      if (!mounted) return;
      setState(() => scale = 1.05);
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() => scale = 1.0);
        timer?..reset()..start();
      });
    });
    timer?.start();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedScale(
      scale: scale,
      duration: duration,
      child: GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        child: Material(
          color: widget.fill ? widget.backgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15.0.r),
          child: Container(
            height: widget.height?.h,
            padding: widget.padding,
            constraints: widget.multiple ? null
                : widget.constraints ?? BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              border: widget.border
                  ? Border.all(color: FTheme.stroke, width: .5)
                  : const Border(),
              borderRadius: BorderRadius.circular(15.0.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.stretch) const Expanded(child: SizedBox()),
                widget.child ?? FText(widget.text!,
                  color: widget.textColor, style: textTheme(context).titleMedium,
                ),
                if (widget.stretch) const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
    return widget.multiple ? Expanded(child: content) : content;
  }
}

class FCircledButton extends StatefulWidget {
  const FCircledButton({
    Key? key,
    required this.onPressed,
    this.onLongPressed,
    required this.child,
    this.size = 80.0,
    this.backgroundColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;
  final Widget child;
  final double size;
  final Color? backgroundColor;

  @override
  State<FCircledButton> createState() => _FCircledButtonState();
}

class _FCircledButtonState extends State<FCircledButton> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;

  double scale = 1.0;
  Duration duration = const Duration(milliseconds: 100);

  bool longPressed = false;

  @override
  void initState() {
    onTapDown = (_) {
      setState(() => scale = .9);
    };
    onTapUp = (_) async {
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() => scale = 1.0);
      });
      widget.onPressed();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: duration,
      child: GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: () => setState(() => scale = 1.0),
        onLongPress: widget.onLongPressed,
        child: Container(
          width: widget.size.r,
          height: widget.size.r,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(10.0.r),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}

class FIconButton extends StatelessWidget {
  const FIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  final FIcon icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(icon.size.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(icon.size.r),
        child: Padding(
          padding: EdgeInsets.all(10.0.r),
          child: icon,
        ),
      ),
    );
  }
}

class FTextButton extends StatefulWidget {
  FTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style,
    this.color = FTheme.grey,
    EdgeInsets? padding,
    this.leading,
    this.action,
  }) : padding = padding ?? EdgeInsets.symmetric(
    horizontal: 20.0.w, vertical: 10.0.h,
  ), super(key: key);

  final VoidCallback? onPressed;
  final String text;
  final TextStyle? style;
  final Color? color;
  final EdgeInsets padding;
  final Icon? leading;
  final Icon? action;

  @override
  State<FTextButton> createState() => _FTextButtonState();
}

class _FTextButtonState extends State<FTextButton> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;
  VoidCallback? onTapCancel;

  Color backgroundColor = Colors.transparent;
  double scale = 1.0;
  double opacity = .0;
  Duration duration = const Duration(milliseconds: 100);

  @override
  void initState() {
    onTapDown = widget.onPressed == null ? null : (_) {
      setState(() {
        backgroundColor = FTheme.black.withOpacity(.1);
        scale = .9; opacity = .2;
      });
    };
    onTapUp = widget.onPressed == null ? null : (_) async {
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() {
          backgroundColor = Colors.transparent;
          scale = 1.0; opacity = .0;
        });
      });
      widget.onPressed!();
    };
    onTapCancel = () => setState(() {
      backgroundColor = Colors.transparent;
      scale = 1.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(12.0.r);

    return AnimatedScale(
      scale: scale,
      duration: duration,
      child: Material(
        color: backgroundColor,
        borderRadius: radius,
        child: GestureDetector(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTapCancel: onTapCancel,
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.leading != null) widget.leading!,
                FText(widget.text, style: widget.style, color: widget.color),
                if (widget.action != null) widget.action!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
