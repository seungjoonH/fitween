import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FPointIcon extends StatelessWidget {
  const FPointIcon({
    super.key,
    this.isWhite = false,
    this.grey = false,
    this.size = 18.0,
  });

  final bool isWhite;
  final bool grey;
  final double size;

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
        width: size,
      ),
    );
  }
}

class FPointAmountWidget extends StatelessWidget {
  const FPointAmountWidget({
    super.key,
    this.amount,
    this.onPressed,
  });

  final int? amount;
  final VoidCallback? onPressed;

  FPointCont get cont => FPointCont.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int value = amount ?? cont.fPoint;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FButton(
            onPressed: onPressed,
            backgroundColor: FTheme.backgroundAlt,
            shrinkWrap: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const FPointIcon(),
                FText(
                  '$value FP',
                  style: FTheme.bodyLarge,
                  color: FTheme.point,
                  bold: true,
                ),
              ],
            ),
          ),
        ],
      );
    });
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
        : FTheme.point;
    Color? borderColor;
    Color backgroundColor = received
        ? FTheme.unselected
        : FTheme.point;

    if (!finished) {
      borderColor = FTheme.point;
      backgroundColor = FTheme.backgroundAlt;
    }

    return FButton(
      stretch: true,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Row(
        children: [
          FPointIcon(isWhite: finished),
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
