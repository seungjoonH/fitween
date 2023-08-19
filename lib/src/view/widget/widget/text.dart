/* 커스텀 텍스트 위젯 */

import 'package:fitween/src/controller/validator/validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FText extends StatelessWidget {
  const FText(this.data, {
    Key? key,
    this.style,
    this.color,
    this.maxLines = 1,
    this.bold = false,
    this.italic = false,
    this.border = false,
    this.borderWidth = .8,
    this.borderColor,
    this.align = TextAlign.left,
    this.shadows,
  }) : super(key: key);

  final String data;
  final TextStyle? style;
  final Color? color;
  final int maxLines;
  final bool bold;
  final bool italic;
  final bool border;
  final double borderWidth;
  final Color? borderColor;
  final TextAlign align;
  final List<Shadow>? shadows;

  FText copy({
    String? data,
    TextStyle? style,
    Color? color,
    int? maxLines,
    bool? bold,
    bool? italic,
    bool? border,
    double? borderWidth,
    Color? borderColor,
    TextAlign? align,
    List<Shadow>? shadows,
  }) {
    return FText(
      data ?? this.data,
      style: style ?? this.style,
      color: color ?? this.color,
      maxLines: maxLines ?? this.maxLines,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      border: border ?? this.border,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      align: align ?? this.align,
      shadows: shadows ?? this.shadows,
    );
  }

  TextStyle? getDefaultStyle(BuildContext context) => FTheme.titleSmall;

  @override
  Widget build(BuildContext context) {
    Color colorAlt = color ?? FTheme.text;
    Color borderColorAlt = borderColor ?? FTheme.textAlt;
    TextStyle? textStyle = style ?? getDefaultStyle(context);
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
          style: mergeStyle.merge(textStyle).apply(
            color: colorAlt,
            shadows: shadows,
          ),
        ),
        if (border)
        Text(data,
          textAlign: align,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: textStyle?.merge(mergeStyle).merge(TextStyle(
            shadows: shadows,
            foreground: border ? (Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = borderWidth
              ..color = borderColorAlt
            ) : null,
          )),
        ),
      ],
    );
  }
}

class FCommentText extends FText {
  const FCommentText(super.data, {
    super.key,
    super.maxLines,
    super.align,
  });

  @override
  String get data => '* ${super.data}';

  @override
  Color? get color => FTheme.comment;

  @override
  TextStyle? getDefaultStyle(context) => FTheme.commentStyle;
}

class FTexts extends StatelessWidget {
  const FTexts(this.text, {
    super.key,
    this.style,
    this.textColor,
    this.highlightColor,
    this.highlightStyle,
    this.highlightColors,
    this.highlightStyles,
    this.align = TextAlign.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final String text;
  final TextStyle? style;
  final Color? textColor;
  final Color? highlightColor;
  final TextStyle? highlightStyle;
  final List<Color>? highlightColors;
  final List<TextStyle>? highlightStyles;
  final TextAlign align;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    TextStyle? styleAlt = style ?? textTheme(context).titleSmall?.copyWith(color: textColor);
    Color textColorAlt = textColor ?? FTheme.text;
    List<String> texts = text.split(RegExp(r'@{|}'));
    List<TextStyle> hStyles = [];

    assert([
      highlightColor, highlightStyle,
      highlightColors, highlightStyles,
    ].where((e) => e != null).length == 1);
    if (highlightColor != null) {
      hStyles = List.generate(
        texts.length ~/ 2, (_) => styleAlt!
          .copyWith(color: highlightColor!),
      );
    }
    else if (highlightColors != null) {
      assert(highlightColors!.length == texts.length ~/ 2);
      hStyles = highlightColors!
          .map((color) => styleAlt!
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

    TextStyle? textStyle = styleAlt?.copyWith(color: textColorAlt);

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

class FInputField extends StatelessWidget {
  const FInputField({
    super.key,
    required this.validator,
    this.keyboardType = TextInputType.text,
  });

  final InputFieldValidatorCont validator;
  final TextInputType keyboardType;

  Color get _hintColor => validator.coloring ? FTheme.error : validator.hintColor;

  @override
  Widget build(BuildContext context) {
    final style = FTheme.bodyLarge?.copyWith(color: FTheme.text);
    final radius = BorderRadius.circular(10.0.r);

    return Obx(() => ShakeWidget(
      autoPlay: validator.shaking,
      shakeConstant: ShakeHorizontalConstant2(),
      child: TextField(
        style: style,
        controller: validator.controller,
        cursorColor: FTheme.text,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              width: 1.0.r,
              color: _hintColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              width: 2.0.r,
              color: FTheme.text,
            ),
          ),
          hintText: validator.hintText,
          hintStyle: FTheme.bodyLarge?.apply(
            color: _hintColor,
          ),
          isDense: true,
        ),
      ),
    ));
  }
}
