import 'package:fitween/global/global.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarDots extends StatelessWidget {
  const CalendarDots({
    super.key,
    required this.completedTypes,
    required this.startedTypes,
  });

  final List<FType> completedTypes;
  final List<FType> startedTypes;

  Widget _buildDotWidget(BuildContext context, Color color) {
    return Container(
      width: 8.0.r,
      height: 8.0.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25.0.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: FType.activeValues.map((type) {
          Color color = Colors.transparent;
          if (startedTypes.contains(type)) { color = FTheme.comment; }
          else if (completedTypes.contains(type)) { color = type.color; }
          if (completedTypes.length == 3) color = FTheme.colorA;
          return _buildDotWidget(context, color);
        }).toList(),
      ),
    );
  }
}