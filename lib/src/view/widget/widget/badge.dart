import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FBadgeWidget extends StatefulWidget {
  const FBadgeWidget({
    super.key,
    this.badge,
    this.size,
    this.backgroundColor,
    this.pressable,
    this.longPressable,
    this.displayCount,
    this.displayMain,
    this.disable,
    this.received,
    this.receivedColor,
    this.border,
  });

  final FBadge? badge;
  final double? size;
  final Color? backgroundColor;
  final bool? pressable;
  final bool? longPressable;
  final bool? displayCount;
  final bool? displayMain;
  final bool? disable;
  final bool? received;
  final Color? receivedColor;
  final bool? border;

  @override
  State<FBadgeWidget> createState() => _FBadgeWidgetState();
}

class _FBadgeWidgetState extends State<FBadgeWidget> with ScalePressable {
  final String _asset = 'assets/image/badge/void.png';

  FBadgeCont get cont => FBadgeCont.to;

  String get _imageUrl => widget.badge?.imageUrl ?? _asset;
  Color get _backgroundColor => widget.backgroundColor ?? AuthCont.logged!.badgeColor;

  double get _size => widget.size ?? 40.0.r;
  bool get _isVoid => widget.badge == null;

  int get _count {
    if (_isVoid) return 0;
    return cont.getCounts(widget.badge!.key);
  }
  bool get _displayCount {
    if (_count == 1) return false;
    return widget.displayCount ?? false;
  }

  bool get _displayMain => widget.displayMain ?? false;
  bool get _pressable => widget.pressable ?? true;
  bool get _longPressable => widget.longPressable ?? true;
  bool get _disable => widget.disable ?? false;
  bool get _received => widget.received ?? false;
  Color get _receivedColor => widget.receivedColor ?? ThemeCont.to.outline;

  Border? get _border => widget.border ?? true ? Border.all(
    width: 1.5,
    color: ThemeCont.to.outline,
    strokeAlign: BorderSide.strokeAlignOutside,
  ) : null;

  Border? get _receivedBorder => _received ? Border.all(
    width: 3.0,
    color: _receivedColor,
    strokeAlign: BorderSide.strokeAlignOutside,
  ) : null;

  Widget _buildBadgeImageWidget(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(_size / 2.4);

    Widget child = Container(
      width: _size,
      height: _size,
      margin: _displayMain
          ? EdgeInsets.all(10.0.r)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: _border,
        borderRadius: radius,
      ),
      child: Image.asset(
        _imageUrl,
        width: _size,
        height: _size,
        fit: BoxFit.contain,
      ),
    );

    if (_disable) return GrayScaleWidget(child: child);
    return Stack(
      children: [
        child,
        if (_received)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              color: ThemeCont.to.seaByMode.withOpacity(.7),
              border: _receivedBorder,
            ),
            child: Icon(
              Icons.check,
              color: _receivedColor,
              size: 40.0.r,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountWidget(BuildContext context) {
    if (!_displayCount) return Container();
    return Container(
      width: 18.0.r,
      height: 18.0.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ThemeCont.to.text,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ThemeCont.to.bar,
            offset: Offset(1.0.r, 1.0.r),
          ),
        ],
      ),
      child: FText(
        '$_count',
        color: ThemeCont.to.backgroundAlt,
        style: ThemeCont.to.bodySmall,
      ),
    );

  }

  Widget _buildMainWidget(BuildContext context) {
    if (_isVoid) return Container();
    return Obx(() {
      if (cont.mainBadge == null) return Container();
      bool isMain = cont.mainBadge!.key == widget.badge!.key;

      if (!_displayMain || !isMain) return Container();
      return Transform.rotate(
        angle: -pi / 4,
        child: const RankIcon(rank: 1),
      );
    });
  }

  @override
  Widget buildContent(BuildContext context) {
    return Stack(
      children: [
        _buildBadgeImageWidget(context),
        Positioned(
          right: .0, bottom: .0,
          child: _buildCountWidget(context),
        ),
        Positioned(
          left: 2.0.r, top: 2.0.r,
          child: _buildMainWidget(context),
        ),
      ],
    );
  }

  @override
  VoidCallback? get onPressed => _pressable
      ? () => FBadgeCont.to.onPressed(widget.badge!) : null;
  @override
  VoidCallback? get onLongPressed => _longPressable
      ? () => FBadgeCont.to.onLongPressed(widget.badge!): null;
}


class FBadgeDetailedWidget extends StatelessWidget {
  const FBadgeDetailedWidget({
    super.key,
    required this.badge,
    this.size,
    this.backgroundColor,
    this.displayTitle = false,
    this.displayDate = false,
    this.pressable,
    this.longPressable,
    this.displayCount,
    this.displayMain,
    this.border,
  });

  final FBadge badge;
  final double? size;
  final Color? backgroundColor;
  final bool displayTitle;
  final bool displayDate;
  final bool? pressable;
  final bool? longPressable;
  final bool? displayCount;
  final bool? displayMain;
  final bool? border;

  Widget _buildTitleWidget(BuildContext context) {
    if (!displayTitle) return Container();

    TextStyle? style = LangCont.isEnglish
        ? ThemeCont.to.bodyMedium
        : ThemeCont.to.bodyLarge;

    return SizedBox(
      height: 25.0.h,
      child: OverflowDetectingText(
        badge.title,
        width: size ?? 40.0.r,
        color: ThemeCont.to.text,
        style: style,
      ),
    );
  }

  Widget _buildDatesWidget(BuildContext context) {
    if (!displayDate) return Container();
    return FText(
      dateToString('yyyy-MM-dd', FBadgeCont.to.getDates(badge.key).first)!,
      style: ThemeCont.to.bodySmall,
      color: ThemeCont.to.comment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FBadgeWidget(
          badge: badge,
          size: size,
          backgroundColor: backgroundColor,
          pressable: pressable,
          longPressable: longPressable,
          displayCount: displayCount,
          displayMain: displayMain,
          border: border,
        ),
        SizedBox(height: 5.0.h),
        _buildTitleWidget(context),
        _buildDatesWidget(context),
      ],
    );
  }
}