import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin ScalePressable<T extends StatefulWidget> on State<T> {
  Function(TapDownDetails)? _onTapDown;
  Function(TapUpDetails)? _onTapUp;
  VoidCallback? _onTapCancel;

  VoidCallback? _withTapDown;
  VoidCallback? _withTapUp;
  VoidCallback? _withTapCancel;

  set withTapDown(VoidCallback? f) => _withTapDown = f;
  set withTapUp(VoidCallback? f) => _withTapUp = f;
  set withTapCancel(VoidCallback? f) => _withTapCancel = f;

  final Duration _duration = const Duration(milliseconds: 100);
  double _scale = 1.0;

  void _setOnTapDown() {
    _onTapDown = onPressed == null ? null : (_) {
      setState(() {
        if (_withTapDown != null) _withTapDown!();
        _scale = .95;
      });
    };
  }

  void _setOnTapUp() {
    _onTapUp = onPressed == null ? null : (_) async {
      await Future.delayed(_duration, () {
        if (!mounted) return;
        setState(() {
          if (_withTapUp != null) _withTapUp!();
          _scale = 1.0;
        });
      });
      onPressed!();
    };
  }

  void _setOnTapCancel() {
    _onTapCancel = () => setState(() {
      if (_withTapCancel != null) _withTapCancel!();
      _scale = 1.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _setOnTapDown();
    _setOnTapUp();
    _setOnTapCancel();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  VoidCallback? get onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: _duration,
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context);
}

mixin DarkPressable<T extends StatefulWidget> on State<T> {
  Function(TapDownDetails)? _onTapDown;
  Function(TapUpDetails)? _onTapUp;
  VoidCallback? _onTapCancel;

  late BorderRadius _radius;

  set radius(BorderRadius r) => _radius = r;

  VoidCallback? _withTapDown;
  VoidCallback? _withTapUp;
  VoidCallback? _withTapCancel;

  set withTapDown(VoidCallback? f) => _withTapDown = f;
  set withTapUp(VoidCallback? f) => _withTapUp = f;
  set withTapCancel(VoidCallback? f) => _withTapCancel = f;

  final Duration _duration = const Duration(milliseconds: 100);
  double _scale = 1.0;
  Color _tintColor = Colors.transparent;
  double _opacity = .0;

  void _setOnTapDown() {
    if (onPressed == null) return;
    _onTapDown = (_) {
      setState(() {
        if (_withTapDown != null) _withTapDown!();
        _scale = .97;
        _opacity = .1;
        _tintColor = FTheme.text;
      });
    };
  }

  void _setOnTapUp() {
    if (onPressed == null) return;
    _onTapUp = (_) async {
      await Future.delayed(_duration, () {
        if (!mounted) return;
        setState(() {
          if (_withTapUp != null) _withTapUp!();
          _scale = 1.0;
          _opacity = .0;
          _tintColor = Colors.transparent;
        });
      });
      onPressed!();
    };
  }

  void _setOnTapCancel() {
    _onTapCancel = () => setState(() {
      if (_withTapCancel != null) _withTapCancel!();
      setState(() {
        _scale = 1.0;
        _opacity = .0;
        _tintColor = Colors.transparent;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _radius = BorderRadius.circular(10.0.r);
    _setOnTapDown();
    _setOnTapUp();
    _setOnTapCancel();
  }

  VoidCallback? get onPressed;
  Color get backgroundColor => Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: _duration,
        child: AnimatedContainer(
          duration: _duration,
          decoration: BoxDecoration(
            borderRadius: _radius,
            color: Color.alphaBlend(
              _tintColor.withOpacity(_opacity),
              backgroundColor,
            ),
          ),
          child: buildContent(context),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context);
}