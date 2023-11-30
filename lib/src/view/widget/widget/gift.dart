import 'package:fitween/global/global.dart';
import 'package:fitween/src/view/widget/button/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gif/gif.dart';

class GiftWidget extends StatefulWidget {
  const GiftWidget({
    super.key,
    this.size,
    this.openingMotion = false,
    this.onPressed,
    this.afterWidget,
  });

  final double? size;
  final bool openingMotion;
  final VoidCallback? onPressed;
  final Widget? afterWidget;

  @override
  State<GiftWidget> createState() => _GiftWidgetState();
}

class _GiftWidgetState extends State<GiftWidget> with TickerProviderStateMixin {
  static const _giftAsset = 'assets/image/page/home/gift';
  String get _svgAsset => '$_giftAsset.svg';
  String get _openingAsset {
    String theme = ThemeCont.to.brightness.name;
    return '${_giftAsset}_opening_$theme.gif';
  }
  String get _closedAsset {
    String theme = ThemeCont.to.brightness.name;
    return '${_giftAsset}_closed_$theme.gif';
  }

  double get _size => widget.size ?? 40.0.r;

  bool get _pressable => widget.onPressed != null;
  bool _pressed = false;

  late GifController _gifCont;
  static const _frameCount = 12.0;
  Duration get _duration => 900.ms;

  double _afterWidgetScale = .8;
  double _afterWidgetOpacity = .0;
  static const double _durationRatio = .9;
  Duration get _afterWidgetDuration => _duration * (1 - _durationRatio);

  bool _activateAfterWidget = false;

  void _visualizeAfterWidget() {
    setState(() {
      _afterWidgetScale = 1.0;
      _afterWidgetOpacity = 1.0;
      _activateAfterWidget = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _gifCont = GifController(vsync: this);
  }

  @override
  void dispose() {
    _gifCont.dispose();
    super.dispose();
  }

  void _onPressed() async {
    if (!_pressable) return;
    if (_pressed) {
      if (_activateAfterWidget) widget.onPressed!();
      return;
    }
    _gifCont.value = 0;
    _gifCont.animateTo(_frameCount, duration: _duration * _frameCount);
    setState(() => _pressed = true);
    await delay(_duration * _durationRatio, _visualizeAfterWidget);
  }

  Widget _buildOpeningGifWidget(BuildContext context) {
    return Gif(
      controller: _gifCont,
      image: AssetImage(_openingAsset),
      width: _size,
      height: _size,
    );
  }

  Widget _buildClosedGifWidget(BuildContext context) {
    return Image.asset(
      _closedAsset,
      width: _size,
      height: _size,
    );
  }

  Widget _buildSvgWidget(BuildContext context) {
    return SvgPicture.asset(
      _svgAsset,
      width: _size,
      height: _size,
    );
  }

  bool get _afterWidgetExists => widget.afterWidget != null;

  Widget _buildChild(BuildContext context) {
    late Widget child;
    if (!_pressable) return _buildSvgWidget(context);

    child = _pressed
        ? _buildOpeningGifWidget(context)
        : _buildClosedGifWidget(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: 1 - _afterWidgetOpacity,
          duration: _afterWidgetDuration,
          child: child,
        ),
        if (_afterWidgetExists)
        AnimatedScale(
          scale: _afterWidgetScale,
          duration: _afterWidgetDuration,
          child: AnimatedOpacity(
            opacity: _afterWidgetOpacity,
            duration: _afterWidgetDuration,
            child: SizedBox(
              width: _size,
              height: _size,
              child: widget.afterWidget!,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScalePressableWidget(
      onPressed: _onPressed,
      child: _buildChild(context),
    );
  }
}