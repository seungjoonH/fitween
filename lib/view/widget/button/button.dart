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
              borderRadius: BorderRadius.circular(15.0),
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

/// class
class PButton extends StatelessWidget {
  PButton({
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
    this.border = true,
    this.height,
  }) : assert(text == null || child == null),
    padding = padding ?? EdgeInsets.symmetric(
      horizontal: 20.0.w, vertical: 10.0.h,
    ),
    backgroundColor = backgroundColor ?? FTheme.black,
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
  final double? height;

  @override
  Widget build(BuildContext context) {
    Widget content = Material(
      color: fill ? backgroundColor : Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        onDoubleTap: onPressed,
        child: Container(
          height: height?.h,
          padding: padding,
          constraints: multiple ? null : constraints ?? BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            border: border
                ? Border.all(color: FTheme.black, width: 1.5)
                : const Border(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (stretch) const Expanded(child: SizedBox()),
              child ??
                  FText(text!, color: textColor, style: textTheme(context).titleMedium),
              if (stretch) const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    return multiple ? Expanded(child: content) : content;
  }
}

class PDirectButton extends StatelessWidget {
  const PDirectButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: FTheme.black),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FText(
              text,
              style: const TextStyle(fontSize: 13.0),
            ),
            const Icon(Icons.arrow_forward_ios, size: 15.0),
          ],
        ),
      ),
    );
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

class FTextButton extends StatelessWidget {
  const FTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.style,
    Color? color,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 5.0,
      vertical: 2.0,
    ),
    this.leading,
    this.action,
  })  : color = color ?? FTheme.black,
        super(key: key);

  final VoidCallback onPressed;
  final String text;
  final TextStyle? style;
  final Color? color;
  final EdgeInsets padding;
  final Icon? leading;
  final Icon? action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) leading!,
              FText(text, style: style, color: color),
              if (action != null) action!,
            ],
          ),
        ),
      ),
    );
  }
}
