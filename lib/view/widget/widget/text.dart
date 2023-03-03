/* 커스텀 텍스트 위젯 */

import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';

/// class
class FText extends StatelessWidget {
  FText(this.data, {
    Key? key,
    TextStyle? style,
    this.color = FTheme.black,
    this.maxLines = 1,
    this.bold = false,
    this.italic = false,
    this.border = false,
    this.borderWidth = .8,
    this.borderColor = FTheme.black,
    this.align = TextAlign.left,
    this.shadows,
  }) : style = style ?? FTheme.textTheme.titleMedium, super(key: key);

  final String data;
  final TextStyle? style;
  final Color? color;
  final int maxLines;
  final bool bold;
  final bool italic;
  final bool border;
  final double borderWidth;
  final Color borderColor;
  final TextAlign align;
  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {
    TextStyle mergeStyle = TextStyle(
      fontWeight: bold
          ? FontWeight.bold
          : FontWeight.normal,
      fontStyle: italic
          ? FontStyle.italic
          : FontStyle.normal,
    );

    return Stack(
      children: [
        Text(data,
          textAlign: align,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: style?.merge(mergeStyle).apply(
            color: color,
            shadows: shadows,
          ),
        ),
        if (border)
        Text(data,
          textAlign: align,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: style?.merge(mergeStyle).merge(TextStyle(
            shadows: shadows,
            foreground: border ? (Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = borderWidth
              ..color = borderColor
            ) : null,
          )),
        ),
      ],
    );
  }
}

class FTexts extends StatelessWidget {
  FTexts(this.texts, {
    Key? key,
    required this.colors,
    TextStyle? style,
    this.bold = false,
    this.italic = false,
    this.border = false,
    this.borderWidth = 1.0,
    this.alignment = MainAxisAlignment.center,
    this.maxLines = 1,
    this.space = true,
    this.shadows,
  }) : assert(texts.length == colors.length),
        style = style ?? textTheme.bodyMedium,
        super(key: key);

  final List<String> texts;
  final List<Color> colors;
  final TextStyle? style;
  final bool bold;
  final bool italic;
  final bool border;
  final double borderWidth;
  final MainAxisAlignment alignment;
  final int maxLines;
  final bool space;
  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(texts.length, (i) => Row(
        children: [
          if (i > 0 && space)
          FText(' ',
            style: style,
            bold: bold,
            italic: italic,
            border: border,
            borderWidth: borderWidth,
            maxLines: maxLines,
            shadows: shadows,
          ),
          FText(texts[i],
            color: colors[i],
            style: style,
            bold: bold,
            italic: italic,
            border: border,
            borderWidth: borderWidth,
            maxLines: maxLines,
            shadows: shadows,
          ),
        ],
      )),
    );
  }
}

class FInputField extends StatelessWidget {
  const FInputField({
    Key? key,
    required this.controller,
    this.hintText,
    this.hintColor = FTheme.lightGrey,
    this.invalid = false,
    this.completed = false,
    this.keyboardType = TextInputType.text,
    this.onEditingComplete,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final Color hintColor;
  final bool invalid;
  final bool completed;
  final TextInputType keyboardType;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {

    return ShakeWidget(
      autoPlay: invalid,
      shakeConstant: ShakeHorizontalConstant2(),
      child: TextField(
        style: textTheme.bodyLarge?.copyWith(color: FTheme.darkGrey),
        controller: controller,
        cursorColor: FTheme.darkGrey,
        keyboardType: keyboardType,
        onSubmitted: (_) {
          if (onEditingComplete != null) onEditingComplete!();
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 1.0,
              color: completed
                  ? FTheme.colorA
                  : hintColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              color: FTheme.darkGrey,
            ),
          ),
          hintText: hintText,
          hintStyle: textTheme.bodyLarge?.apply(
            color: completed && hintText != null
                ? FTheme.colorA : hintColor,
          ),
          isDense: true,
        ),
      ),
    );
  }
}
