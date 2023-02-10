/* 커스텀 텍스트 위젯 */

import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';

/// class
class PText extends StatelessWidget {
  PText(this.data, {
    Key? key,
    TextStyle? style,
    this.color = PTheme.black,
    this.maxLines = 1,
    this.bold = false,
    this.italic = false,
    this.border = false,
    this.borderWidth = .8,
    this.borderColor = PTheme.black,
    this.align = TextAlign.left,
    this.shadows,
  }) : style = style ?? PTheme.textTheme.bodyMedium, super(key: key);

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

class PTexts extends StatelessWidget {
  PTexts(this.texts, {
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
          PText(' ',
            style: style,
            bold: bold,
            italic: italic,
            border: border,
            borderWidth: borderWidth,
            maxLines: maxLines,
            shadows: shadows,
          ),
          PText(texts[i],
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

class PInputField extends StatelessWidget {
  const PInputField({
    Key? key,
    required this.controller,
    this.hintText,
    this.hintColor = PTheme.grey,
    this.invalid = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final Color hintColor;
  final bool invalid;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      autoPlay: invalid,
      shakeConstant: ShakeHorizontalConstant2(),
      child: TextField(
        style: textTheme.bodyLarge,
        controller: controller,
        cursorColor: PTheme.black,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: hintColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: PTheme.black, width: 2.0),
          ),
          hintText: hintText,
          hintStyle: textTheme.bodyLarge?.apply(color: hintColor),
          isDense: true,
        ),
      ),
    );
  }
}
