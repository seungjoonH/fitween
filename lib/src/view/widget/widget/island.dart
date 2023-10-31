import 'dart:async';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/button/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FIslandWidget extends StatefulWidget {
  const FIslandWidget({
    super.key,
    required this.level,
    this.width,
    this.height,
    this.period = 1000,
    this.onPressed,
    this.hide = false,
  });

  final Level level;
  final double? width;
  final double? height;
  final int period;
  final VoidCallback? onPressed;
  final bool hide;

  @override
  State<FIslandWidget> createState() => _FIslandWidgetState();
}

class _FIslandWidgetState extends State<FIslandWidget> {
  static const _defaultAmplitude = 10.0;
  double _y = 0;
  int _dir = 1;
  late Timer? _timer;

  void _floating() {
    _timer = Timer.periodic(widget.period.ms, (_) {
      setState(() {
        _y += _dir * _defaultAmplitude.h;
        _dir *= -1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _floating();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  double get width {
    if (!widget.hide) return imageWidth;
    return imageWidth * 3.0;
  }
  double get height => imageWidth * 2.2;
  double get imageWidth => widget.width ?? 100.0.r;

  String get darkSideUrl => 'assets/image/page/contents/adventure/dark_side.png';

  String get imageUrl {
    return widget.hide
        ? Level.voidUrl
        : widget.level.imageUrl;
  }

  bool get _isNight => FTheme.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return ScalePressableWidget(
      onPressed: widget.onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isNight)
          Container(
            width: 140.0.r,
            height: 140.0.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color.alphaBlend(
                    Colors.yellow.withOpacity(.5),
                    FTheme.darkSea,
                  ),
                  FTheme.darkSea.withOpacity(.0),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: 1.s,
                  bottom: _y,
                  curve: Curves.easeInOut,
                  child: Hero(
                    tag: widget.level.key,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset(
                          imageUrl,
                          width: imageWidth,
                        ),
                        if (_isNight)
                        Image.asset(
                          darkSideUrl,
                          width: imageWidth,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}