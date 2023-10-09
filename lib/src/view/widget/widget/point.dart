import 'package:fitween/global/global.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FPointWidget extends StatelessWidget {
  const FPointWidget({
    super.key,
    this.isWhite = false,
    this.grey = false,
  });

  final bool isWhite;
  final bool grey;

  static const _asset = 'assets/image/logo/point';
  static const _purple = '${_asset}_purple.svg';
  static const _white = '${_asset}_white.svg';

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: grey ? ColorFilter.mode(
        FTheme.comment,
        BlendMode.saturation,
      ) : const ColorFilter.mode(
        Colors.transparent,
        BlendMode.multiply,
      ),
      child: SvgPicture.asset(
        isWhite ? _white : _purple,
        width: 18.0.w,
      ),
    );
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

class FPointButton extends StatelessWidget {
  const FPointButton({
    super.key,
    required this.amount,
    this.received = false,
    this.finished = false,
    this.onPressed,
  });

  final int amount;
  final bool received;
  final bool finished;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    Color textColor = finished
        ? FTheme.achro90
        : FTheme.colorE;
    Color? borderColor;
    Color backgroundColor = received
        ? FTheme.unselected
        : FTheme.colorE;

    if (!finished) {
      borderColor = FTheme.colorE;
      backgroundColor = FTheme.backgroundAlt;
    }

    return FButton(
      stretch: true,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Row(
        children: [
          FPointWidget(isWhite: finished),
          SizedBox(width: 2.0.w),
          FText(
            '${amount.thouSep} FP',
            style: FTheme.titleSmall,
            color: textColor,
            bold: true,
          ),
        ],
      ),
    );
  }
}
