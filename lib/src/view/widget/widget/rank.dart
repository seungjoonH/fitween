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
    if (widget.rank == 0) return Container();
    return widget.rank > 3 ? Container(
      width: 20.0.r,
      height: 20.0.r,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: ThemeCont.to.text,
        shape: BoxShape.circle,
      ),
      child: FText(
        '${widget.rank}',
        color: ThemeCont.to.background,
        style: ThemeCont.to.bodyLarge,
      ),
    ) : SvgPicture.asset(
      '$asset${widget.rank}.svg',
      width: 15.0.r,
      height: 15.0.r,
    );
  }
}
