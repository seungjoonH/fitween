import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FTag extends StatelessWidget {
  const FTag(this.text, {
    Key? key,
    this.textColor = FTheme.white,
    this.backgroundColor = FTheme.lightGrey,
  }) : super(key: key);

  final String text;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0, vertical: 2.0,
      ),
      margin: const EdgeInsets.only(left: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: FText(text,
        style: textTheme.labelSmall,
        color: textColor,
      ),
    );
  }
}

class MeTag extends StatelessWidget {
  const MeTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FTag('ME',
      textColor: FTheme.white,
      backgroundColor: FTheme.darkGrey,
    );
  }
}
