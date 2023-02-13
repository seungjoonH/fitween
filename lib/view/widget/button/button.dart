/* 커스텀 버튼 위젯 */

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/icon.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';

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
  }) : assert(
  text == null || child == null,
  ), padding = padding ?? EdgeInsets.symmetric(
    horizontal: 20.0.w, vertical: 10.0.h,
  ), backgroundColor = backgroundColor ?? FTheme.black,
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
              child ?? FText(text!, color: textColor, style: textTheme.titleMedium),
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
            FText(text,
              style: const TextStyle(fontSize: 13.0),
            ),
            const Icon(Icons.arrow_forward_ios, size: 15.0),
          ],
        ),
      ),
    );
  }
}

class PCircledButton extends StatelessWidget {
  const PCircledButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.size = 80.0,
    this.enabled = true,
    Color? backgroundColor,
  }) : backgroundColor = backgroundColor ?? const Color(0xFFD6BDAC),
        super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final double size;
  final bool enabled;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(size.r * .5);
    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          color: backgroundColor,
          borderRadius: radius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Container(
              padding: EdgeInsets.all(10.0.r),
              alignment: Alignment.center,
              width: size.r,
              height: size.r,
              child: child,
            ),
          ),
        ),
        if (!enabled)
        Container(
          width: size.r,
          height: size.r,
          decoration: BoxDecoration(
            color: FTheme.white.withOpacity(.3),
            borderRadius: radius,
          ),
        ),
      ],
    );
  }
}

class PIconButton extends StatelessWidget {
  const PIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    Color? backgroundColor,
    Color? iconColor,
  }) : backgroundColor = backgroundColor ?? const Color(0xFFD6BDAC),
        super(key: key);

  final PIcon icon;
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
      horizontal: 5.0, vertical: 2.0,
    ),
    this.leading,
    this.action,
  }) : color = color ?? FTheme.black,  super(key: key);

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
