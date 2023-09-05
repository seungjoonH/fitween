import 'package:fitween/global/theme.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FTextButton extends StatefulWidget {
  const FTextButton({
    super.key,
    this.text,
    this.child,
    this.style,
    this.textColor,
    this.bold = false,
    this.border = false,
    this.onPressed,
    this.alignment,
    this.stretch = false,
    this.padding,
    this.shrinkWrap = false,
  });

  final String? text;
  final Widget? child;
  final TextStyle? style;
  final Color? textColor;
  final bool bold;
  final bool border;
  final VoidCallback? onPressed;
  final ButtonAlignment? alignment;
  final bool stretch;
  final EdgeInsets? padding;
  final bool shrinkWrap;

  @override
  State<FTextButton> createState() => _FTextButtonState();
}

class _FTextButtonState extends State<FTextButton> with DarkPressable<FTextButton> {
  EdgeInsets? get padding => widget.shrinkWrap ? EdgeInsets.symmetric(
    horizontal: 8.0.r, vertical: 4.0.r,
  ) : widget.padding;

  @override
  Widget buildContent(BuildContext context) {
    return FButton(
      text: widget.text,
      style: widget.style,
      bold: widget.bold,
      textColor: widget.textColor ?? FTheme.text,
      backgroundColor: Colors.transparent,
      border: widget.border,
      onPressed: widget.onPressed,
      alignment: widget.alignment,
      stretch: widget.stretch,
      padding: padding,
      child: widget.child,
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}
