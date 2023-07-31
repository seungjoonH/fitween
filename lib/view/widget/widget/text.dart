/* 커스텀 텍스트 위젯 */

import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';

/// class
class FText extends StatelessWidget {
  FText(this.data, {
    Key? key,
    TextStyle? style,
    this.color = FTheme.darkGrey,
    this.maxLines = 1,
    this.bold = false,
    this.italic = false,
    this.border = false,
    this.borderWidth = .8,
    this.borderColor = FTheme.black,
    this.align = TextAlign.left,
    this.shadows,
  }) : style = style ?? FTheme.textTheme.titleSmall, super(key: key);

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

class FTextsT extends StatelessWidget {
  FTextsT(this.text, {
    super.key,
    TextStyle? style,
    this.textColor = FTheme.darkGrey,
    this.highlightColor,
    this.highlightStyle,
    this.highlightColors,
    this.highlightStyles,
    this.align = TextAlign.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : style = style ?? FTheme.textTheme.titleSmall?.copyWith(color: textColor);

  final String text;
  final TextStyle? style;
  final Color textColor;
  final Color? highlightColor;
  final TextStyle? highlightStyle;
  final List<Color>? highlightColors;
  final List<TextStyle>? highlightStyles;
  final TextAlign align;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    List<String> texts = text.split(RegExp(r'@{|}'));
    List<TextStyle> hStyles = [];

    assert([
      highlightColor, highlightStyle,
      highlightColors, highlightStyles,
    ].where((e) => e != null).length == 1);
    if (highlightColor != null) {
      hStyles = List.generate(
        texts.length ~/ 2, (_) => style!
          .copyWith(color: highlightColor!),
      );
    }
    else if (highlightColors != null) {
      assert(highlightColors!.length == texts.length ~/ 2);
      hStyles = highlightColors!
          .map((color) => style!
          .copyWith(color: color)).toList();
    }
    else if (highlightStyle != null) {
      hStyles = List.generate(
        texts.length ~/ 2, (_) => highlightStyle!,
      );
    }
    else if (highlightStyles != null) {
      assert(highlightStyles!.length == texts.length ~/ 2);
      hStyles = highlightStyles!;
    }

    TextStyle? textStyle = style?.copyWith(color: textColor);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: align,
          text: TextSpan(
            style: textStyle,
            children: List.generate(
              texts.length, (i) => TextSpan(
                text: texts[i],
                style: i % 2 == 0
                    ? textStyle : hStyles[i ~/ 2],
              ),
            ),
          ),
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
        style = style ?? FTheme.textTheme.titleMedium,
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
    this.style,
    this.invalid = false,
    this.completed = false,
    this.keyboardType = TextInputType.text,
    this.onEditingComplete,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final Color hintColor;
  final TextStyle? style;
  final bool invalid;
  final bool completed;
  final TextInputType keyboardType;
  final VoidCallback? onEditingComplete;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = style ?? textTheme(context).bodyMedium;

    return ShakeWidget(
      autoPlay: invalid,
      shakeConstant: ShakeHorizontalConstant2(),
      child: TextField(
        style: textStyle?.copyWith(color: FTheme.darkGrey),
        controller: controller,
        cursorColor: FTheme.darkGrey,
        keyboardType: keyboardType,
        maxLines: maxLines,
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
          hintStyle: textTheme(context).bodyMedium?.copyWith(
            color: completed && hintText != null
                ? FTheme.colorA : hintColor,
          ),
          isDense: true,
        ),
      ),
    );
  }
}
