import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';

enum DialogType { none, mono, bi }

class DialogButtonData {
  late DialogType type;
  String text;
  Color textColor;
  Color backgroundColor;
  VoidCallback onPressed;

  DialogButtonData(
    type, {
    Color? textColor,
    Color? backgroundColor,
    required this.text,
    required this.onPressed,
  }) : textColor = textColor ?? FTheme.backgroundAlt,
        backgroundColor = backgroundColor ?? FTheme.textAlt;
}

Future<bool> showFDialog({
  String? title,
  required Widget content,
  CrossAxisAlignment contentAlignment = CrossAxisAlignment.center,
  EdgeInsets? titlePadding,
  EdgeInsets? contentPadding,
  DialogType type = DialogType.none,
  String? buttonText,
  VoidCallback? onPressed,
  Color? color,
  String? leftText,
  String? rightText,
  VoidCallback? leftPressed,
  VoidCallback? rightPressed,
  Color? leftTextColor,
  Color? rightTextColor,
  Color? leftBackgroundColor,
  Color? rightBackgroundColor,
  bool barrierDismissible = true,
}) async {
  switch (type) {
    case DialogType.bi:
      // assert(onPressed == null &&
      //     buttonText == null &&
      //     (leftPressed != null && rightPressed != null));
      assert(buttonText == null);
      break;
    case DialogType.mono:
      // assert(onPressed != null &&
      //     (leftText == null &&
      //         leftPressed == null &&
      //         rightText == null &&
      //         rightPressed == null));
      assert(leftText == null && rightText == null);
      break;
    case DialogType.none:
      // assert(onPressed == null &&
      //     buttonText == null &&
      //     (leftText == null &&
      //         leftPressed == null &&
      //         leftTextColor == null &&
      //         leftBackgroundColor == null &&
      //         rightText == null &&
      //         rightPressed == null &&
      //         rightTextColor == null &&
      //         rightBackgroundColor == null));
      assert(buttonText == null &&
          (leftText == null &&
              leftTextColor == null &&
              leftBackgroundColor == null &&
              rightText == null &&
              rightTextColor == null &&
              rightBackgroundColor == null));
      break;
  }

  titlePadding = EdgeInsets.only(top: 20.0.r, left: 20.0.r);
  contentPadding = EdgeInsets.all(20.0.r);

  leftPressed = () => Get.back(result: false);
  rightPressed = () => Get.back(result: true);
  onPressed = rightPressed;

  if (content is FText) {
    content = content.copy(style: FTheme.textTheme.bodyLarge);
  }

  return await Get.dialog<bool>(
    FAlertDialog(
      title: title,
      content: content,
      contentAlignment: contentAlignment,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      type: type,
      buttonText: buttonText,
      onPressed: onPressed,
      color: color,
      leftText: leftText,
      rightText: rightText,
      leftPressed: leftPressed,
      rightPressed: rightPressed,
      leftTextColor: leftTextColor,
      rightTextColor: rightTextColor,
      leftBackgroundColor: leftBackgroundColor,
      rightBackgroundColor: rightBackgroundColor,
    ),
    barrierDismissible: barrierDismissible,
  ) ?? false;
}

class FAlertDialog extends StatefulWidget {
  const FAlertDialog({
    Key? key,
    this.title,
    required this.content,
    this.contentAlignment = CrossAxisAlignment.start,
    this.titlePadding,
    this.contentPadding,
    this.type = DialogType.none,
    this.buttonText,
    this.onPressed,
    this.color,
    this.leftText,
    this.rightText,
    this.leftPressed,
    this.rightPressed,
    this.leftTextColor,
    this.rightTextColor,
    this.leftBackgroundColor,
    this.rightBackgroundColor,
  }) : super(key: key);

  final String? title;
  final Widget content;
  final CrossAxisAlignment contentAlignment;
  final EdgeInsets? titlePadding;
  final EdgeInsets? contentPadding;
  final DialogType type;
  final String? buttonText;
  final VoidCallback? onPressed;
  final Color? color;
  final String? leftText;
  final String? rightText;
  final VoidCallback? leftPressed;
  final VoidCallback? rightPressed;
  final Color? leftTextColor;
  final Color? rightTextColor;
  final Color? leftBackgroundColor;
  final Color? rightBackgroundColor;

  @override
  State<FAlertDialog> createState() => _FAlertDialogState();
}

class _FAlertDialogState extends State<FAlertDialog> {
  @override
  Widget build(BuildContext context) {
    List<DialogButtonData> data = [];

    switch (widget.type) {
      case DialogType.none: break;
      case DialogType.mono:
        data = [
          DialogButtonData(
            widget.type,
            text: widget.buttonText ?? '확인',
            backgroundColor: widget.color ?? FTheme.text,
            onPressed: widget.onPressed!,
          ),
        ];
        break;
      case DialogType.bi:
        data = [
          DialogButtonData(
            widget.type,
            text: widget.leftText ?? '취소',
            textColor: widget.leftTextColor ?? FTheme.backgroundAlt,
            backgroundColor: widget.leftBackgroundColor ?? FTheme.bar,
            onPressed: widget.leftPressed!,
          ),
          DialogButtonData(
            widget.type,
            text: widget.rightText ?? '확인',
            textColor: widget.rightTextColor ?? FTheme.backgroundAlt,
            backgroundColor: widget.rightBackgroundColor ?? FTheme.text,
            onPressed: widget.rightPressed!,
          ),
        ];
        break;
    }

    assert(widget.type.index == data.length);

    BorderRadius radius = BorderRadius.circular(12.0.r);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: radius),
      backgroundColor: FTheme.backgroundAlt,
      title: Container(
        padding: widget.titlePadding,
        child: FText(
          widget.title ?? '',
          bold: true,
          style: FTheme.titleLarge,
        ),
      ),
      titlePadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * .5,
        constraints: BoxConstraints(maxWidth: 500.0.w),
        child: ClipRRect(
          borderRadius: radius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: widget.contentAlignment,
            children: [
              Container(
                padding: widget.contentPadding,
                constraints: BoxConstraints(
                  minWidth: 380.0.r,
                  minHeight: 70.0.r,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0.r),
                  child: widget.content,
                ),
              ),
              Row(
                children: data.map((datum) => Expanded(
                  child: Material(
                    color: datum.backgroundColor,
                    child: InkWell(
                      onTap: datum.onPressed,
                      child: Container(
                        padding: EdgeInsets.all(10.0.r),
                        child: Center(
                          child: FText(
                            datum.text,
                            color: datum.textColor,
                            style: FTheme.labelLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
