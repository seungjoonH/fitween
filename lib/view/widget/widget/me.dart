import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeTagWidget extends StatelessWidget {
  const MeTagWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0, vertical: 1.0,
      ),
      margin: const EdgeInsets.only(left: 5.0),
      decoration: BoxDecoration(
        color: FTheme.darkGrey,
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: FText('ME',
        style: textTheme.bodySmall,
        color: FTheme.white,
      ),
    );
  }
}
