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
    this.size = 30.0,
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
        ThemeCont.to.comment,
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

  Widget _buildWidget(BuildContext context, int amount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FButton(
          onPressed: onPressed,
          backgroundColor: ThemeCont.to.backgroundAlt,
          shrinkWrap: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FText(
                amount.thouSep,
                style: ThemeCont.to.bodyLarge,
                color: ThemeCont.to.point,
                bold: true,
              ),
              SizedBox(width: 5.0.w),
              const FPointIcon(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (amount != null) return _buildWidget(context, amount!);
    return Obx(() => _buildWidget(context, cont.fPoint));
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

  bool get _receivable => !received && finished && amount != 0;

  @override
  Widget build(BuildContext context) {
    Color textColor = finished
        ? ThemeCont.achro90
        : ThemeCont.to.point;
    Color? borderColor;
    Color backgroundColor = _receivable
        ? ThemeCont.to.point
        : ThemeCont.to.unselected;

    if (!finished) {
      borderColor = ThemeCont.to.point;
      backgroundColor = ThemeCont.to.backgroundAlt;
    }

    return FButton(
      stretch: true,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Row(
        children: [
          FText(
            amount.thouSep,
            style: ThemeCont.to.titleSmall,
            color: textColor,
            bold: true,
          ),
          SizedBox(width: 2.0.w),
          FPointIcon(isWhite: finished),
        ],
      ),
    );
  }
}
