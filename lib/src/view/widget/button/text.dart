import 'package:fitween/src/controller/theme.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget buildContent(BuildContext context) {
    return FButton(
      text: widget.text,
      style: widget.style,
      bold: widget.bold,
      textColor: widget.textColor ?? ThemeCont.to.text,
      backgroundColor: Colors.transparent,
      border: widget.border,
      onPressed: widget.onPressed,
      alignment: widget.alignment,
      stretch: widget.stretch,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      child: widget.child,
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}
