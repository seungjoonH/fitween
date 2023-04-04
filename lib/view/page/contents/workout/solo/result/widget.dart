import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  const CountWidget({
    Key? key,
    required this.count,
    this.textStyle,
  }) : super(key: key);

  final int count;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FText('+', color: ActivityType.weight.color, style: textStyle),
        AnimatedFlipCounter(
          value: count,
          prefix: '+', suffix: '회',
          textStyle: textStyle?.copyWith(color: ActivityType.weight.color),
        ),
        FText('회', color: ActivityType.weight.color, style: textStyle),
      ],
    );
  }
}
