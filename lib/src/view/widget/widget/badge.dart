import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FBadgeWidget extends StatefulWidget {
  const FBadgeWidget({
    super.key,
    this.badge,
    this.onPressed,
    this.size = 40.0,
    this.backgroundColor,
  });

  final FBadge? badge;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;

  @override
  State<FBadgeWidget> createState() => _FBadgeWidgetState();
}

class _FBadgeWidgetState extends State<FBadgeWidget> with ScalePressable {
  final String _asset = 'assets/image/badge/void.svg';

  String get _imagePath => widget.badge?.imagePath ?? _asset;
  Color get _backgroundColor => widget.backgroundColor ?? AuthCont.logged!.badgeColor;

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      width: widget.size.r,
      height: widget.size.r,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(widget.size.r / 2.25),
      ),
      child: SvgPicture.asset(
        _imagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed ?? () {};
}