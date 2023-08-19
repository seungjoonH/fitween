import 'package:fitween/global/global.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RankIcon extends FWidget {
  const RankIcon({
    super.key,
    required this.rank,
  });

  final int rank;

  @override
  FWidgetState<RankIcon> createState() => _RankIconState();
}

class _RankIconState extends FWidgetState<RankIcon> {

  static const String asset = 'assets/image/widget/ranking/';

  @override
  Widget buildWidget(BuildContext context) {
    return widget.rank > 4 ? Container(
      decoration: BoxDecoration(
        color: FTheme.text,
        shape: BoxShape.circle,
      ),
      child: FText(
        '${widget.rank}',
        color: FTheme.background,
        style: FTheme.bodySmall,
      ),
    ) : SvgPicture.asset(
      '$asset${widget.rank}.svg',
      width: 15.0.r,
      height: 15.0.r,
    );
  }
}
