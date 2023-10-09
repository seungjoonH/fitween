import 'package:fitween/global/theme.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FTag extends FWidget {
  const FTag(this.text, {
    Key? key,
    this.textColor,
    this.backgroundColor,
    this.leftMargin = false,
  }) : super(key: key);

  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final bool leftMargin;

  @override
  FTagState createState() => FTagState();
}

class FTagState extends FWidgetState<FTag> {
  @override
  Widget buildWidget(BuildContext context) {
    Color textColorAlt = widget.textColor ?? FTheme.backgroundAlt;
    Color backgroundColorAlt = widget.backgroundColor ?? FTheme.bar;

    EdgeInsets? margin;
    if (widget.leftMargin) margin = EdgeInsets.only(left: 5.0.r);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5.0.r, vertical: 1.0.r,
      ),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColorAlt,
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: FText(widget.text,
        style: FTheme.labelLarge,
        color: textColorAlt,
      ),
    );
  }
}

class MeTag extends StatelessWidget {
  const MeTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FTag('ME',
      textColor: FTheme.backgroundAlt,
      backgroundColor: FTheme.text,
    );
  }
}
