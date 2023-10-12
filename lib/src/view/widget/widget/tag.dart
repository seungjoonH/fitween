import 'package:fitween/global/theme.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    Color backgroundColorAlt = widget.backgroundColor ?? FTheme.unselected;

    EdgeInsets? margin;
    if (widget.leftMargin) margin = EdgeInsets.only(left: 5.0.r);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.0.r, vertical: 2.0.r,
      ),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColorAlt,
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: FText(widget.text,
        style: FTheme.labelMedium,
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

class FTypeTag extends StatelessWidget {
  const FTypeTag({
    super.key,
    required this.type,
  });

  final FType type;

  @override
  Widget build(BuildContext context) {
    return FTag(
      type.locale.capitalize!,
      textColor: FTheme.achro95,
      backgroundColor: type.color,
    );
  }
}


class DifficultyTag extends StatelessWidget {
  const DifficultyTag({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    bool normal = difficulty == Difficulty.normal;

    return FTag(
      difficulty.locale.capitalize!,
      textColor: normal
          ? FTheme.achro5
          : FTheme.achro95,
      backgroundColor: difficulty.color,
    );
  }
}