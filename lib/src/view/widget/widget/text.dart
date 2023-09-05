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
    this.align = TextAlign.left,
  }) : super(key: key);

  final String data;
  final TextStyle? style;
  final Color? color;
  final int maxLines;
  final bool bold;
  final bool italic;
  final TextAlign align;

  FText copy({
    String? data,
    TextStyle? style,
    Color? color,
    int? maxLines,
    bool? bold,
    bool? italic,
    TextAlign? align,
  }) {
    return FText(
      data ?? this.data,
      style: style ?? this.style,
      color: color ?? this.color,
      maxLines: maxLines ?? this.maxLines,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      align: align ?? this.align,
    );
  }

  TextStyle? get defaultStyle => FTheme.titleSmall;

  @override
  Widget build(BuildContext context) {
    Color colorAlt = color ?? FTheme.text;
    TextStyle? textStyle = style ?? defaultStyle;
    TextStyle mergeStyle = TextStyle(
      fontWeight: bold
          ? FontWeight.bold
          : textStyle?.fontWeight,
      fontStyle: italic
          ? FontStyle.italic
          : textStyle?.fontStyle,
      color: colorAlt,
    );

    return Text(
      data,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: textStyle?.merge(mergeStyle),
    );
  }
}

class FCommentText extends FText {
  const FCommentText(super.data, {
    super.key,
    super.maxLines,
    super.align,
    this.withAsterisk = true,
  });

  final bool withAsterisk;

  @override
  String get data {
    String prefix = withAsterisk ? '*' : '';
    return '$prefix ${super.data}';
  }

  @override
  Color? get color => FTheme.comment;

  @override
  TextStyle? get defaultStyle => FTheme.commentStyle;
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

class FSearchField extends StatelessWidget {
  const FSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
  });

  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.w, vertical: 5.0.h,
      ),
      decoration: BoxDecoration(
        color: FTheme.bar,
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: FTheme.comment),
          SizedBox(width: 10.0.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: FTheme.text,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: FTheme.titleMedium
                    ?.apply(color: FTheme.comment),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
