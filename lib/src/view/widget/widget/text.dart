import 'package:fitween/src/controller/validator/validator.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:fitween/src/controller/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

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

  TextStyle? get defaultStyle => ThemeCont.to.titleSmall;

  bool get textWrap => maxLines == 0;

  @override
  Widget build(BuildContext context) {
    Color colorAlt = color ?? ThemeCont.to.text;
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
      maxLines: textWrap ? null : maxLines,
      overflow: textWrap
          ? TextOverflow.visible
          : TextOverflow.ellipsis,
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
  Color? get color => ThemeCont.to.comment;

  @override
  TextStyle? get defaultStyle => ThemeCont.to.commentStyle;
}

class OverflowDetectingText extends StatelessWidget {
  const OverflowDetectingText(this.data, {
    super.key,
    required this.width,
    this.style,
    this.color,
  });

  final String data;
  final double width;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    TextPainter painter = TextPainter(
      text: TextSpan(text: data, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    return Container(
      width: width,
      alignment: Alignment.center,
      child: LayoutBuilder(
          builder: (context, constraints) {
            painter.layout(maxWidth: constraints.maxWidth);
            if (painter.didExceedMaxLines) {
              return Marquee(
                text: data,
                style: style?.copyWith(color: color),
                fadingEdgeStartFraction: .3,
                fadingEdgeEndFraction: .3,
                velocity: 15.0,
                blankSpace: width,
              );
            }
            return FText(
              data,
              style: style,
              color: color,
              align: TextAlign.center,
            );
          }
      ),
    );
  }
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
    this.wordWrap = false,
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
  final bool wordWrap;

  @override
  Widget build(BuildContext context) {
    TextStyle? styleAlt = style ?? textTheme(context).titleSmall?.copyWith(color: textColor);
    Color textColorAlt = textColor ?? ThemeCont.to.text;
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

    RichText textWidget = RichText(
      textAlign: align,
      text: TextSpan(
        style: textStyle,
        children: List.generate(
            texts.length, (i) => TextSpan(
          text: texts[i],
          style: i % 2 == 0
              ? textStyle : hStyles[i ~/ 2],
        )),
      ),
    );

    return wordWrap ? textWidget : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ textWidget ],
    );
  }
}

class FTextField extends StatelessWidget {
  const FTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.hintText,
    this.onChanged,
    this.clearPressed,
  });

  final TextEditingController controller;
  final Widget? prefixIcon;
  final String? hintText;
  final Function(String)? onChanged;
  final VoidCallback? clearPressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: ThemeCont.to.text,
      style: ThemeCont.to.titleMedium?.copyWith(color: ThemeCont.to.text),
      autofocus: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: ThemeCont.to.titleMedium?.apply(color: ThemeCont.to.comment),
        prefixIcon: prefixIcon ?? Icon(Icons.edit, size: 18.0.r),
        prefixIconColor: ThemeCont.to.comment,
        suffixIcon: FIconButton(
          icon: const Icon(Icons.cancel),
          size: 18.0,
          iconSize: 17.0,
          iconColor: ThemeCont.to.comment,
          onPressed: clearPressed,
        ),
        isDense: true,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5.0.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5.0.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: ThemeCont.to.bar,
        focusColor: ThemeCont.to.bar,
      ),
    );
  }
}


class FInputField extends StatelessWidget {
  const FInputField({
    super.key,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines,
  });

  final InputFieldValidatorCont validator;
  final TextInputType keyboardType;
  final int? maxLines;

  Color get _hintColor => validator.coloring
      ? ThemeCont.error
      : validator.hintColor;

  @override
  Widget build(BuildContext context) {
    final style = ThemeCont.to.bodyLarge
        ?.copyWith(color: ThemeCont.to.text);
    final radius = BorderRadius.circular(10.0.r);

    return Obx(() => ShakeWidget(
      autoPlay: validator.shaking,
      shakeConstant: ShakeHorizontalConstant2(),
      child: TextField(
        style: style,
        controller: validator.controller,
        cursorColor: ThemeCont.to.text,
        keyboardType: keyboardType,
        maxLines: maxLines,
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
              color: ThemeCont.to.text,
            ),
          ),
          hintText: validator.hintText,
          hintStyle: ThemeCont.to.bodyLarge?.apply(
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
        color: ThemeCont.to.bar,
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: ThemeCont.to.comment),
          SizedBox(width: 10.0.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: ThemeCont.to.text,
              style: ThemeCont.to.titleMedium
                  ?.apply(color: ThemeCont.to.text),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: ThemeCont.to.titleMedium
                    ?.apply(color: ThemeCont.to.comment),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
