import 'package:fitween/global/global.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FPointWidget extends StatelessWidget {
  const FPointWidget({super.key});

  static const _asset = 'assets/image/logo/point.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_asset, width: 18.0.w);
  }
}


class FPointAmountWidget extends StatelessWidget {
  const FPointAmountWidget({
    super.key,
    required this.amount,
    this.onPressed,
  });

  final int amount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPressed: onPressed,
      shrinkWrap: true,
      backgroundColor: FTheme.backgroundAlt,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const FPointWidget(),
          FText(
            '$amount FP',
            style: FTheme.bodyLarge,
            color: FTheme.point,
            bold: true,
          ),
        ],
      ),
    );
  }
}
