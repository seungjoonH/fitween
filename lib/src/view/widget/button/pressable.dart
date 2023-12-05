import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScalePressableWidget extends StatefulWidget {
  const ScalePressableWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPressed,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;

  @override
  State<ScalePressableWidget> createState() => _ScalePressableWidgetState();
}

class _ScalePressableWidgetState extends State<ScalePressableWidget> with ScalePressable {
  @override
  Widget buildContent(BuildContext context) => widget.child;

  @override
  VoidCallback? get onPressed => widget.onPressed;
  @override
  VoidCallback? get onLongPressed => widget.onLongPressed;
}

class DarkPressableWidget extends StatefulWidget {
  const DarkPressableWidget({
    super.key,
    required this.child,
    this.rounded = true,
    this.onPressed,
  });

  final Widget child;
  final bool rounded;
  final VoidCallback? onPressed;

  @override
  State<DarkPressableWidget> createState() => _DarkPressableWidgetState();
}

class _DarkPressableWidgetState extends State<DarkPressableWidget> with DarkPressable {
  @override
  Widget buildContent(BuildContext context) => widget.child;

  @override
  BorderRadius? get radius => widget.rounded
      ? super.radius
      : BorderRadius.zero;

  @override
  VoidCallback? get onPressed => widget.onPressed;
}


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

  final Duration _duration = 100.ms;
  double scale = 1.0;

  bool get allowPressEffect => true;
  double get pressedScale => .97;

  bool pressed = false;
  bool longPressed = false;

  void _setOnTapDown() {
    _onTapDown = onPressed == null ? null : (_) {
      setState(() {
        pressed = true;
        if (_withTapDown != null) _withTapDown!();
        if (allowPressEffect) scale = pressedScale;
      });
    };
  }

  void _setOnTapUp() {
    _onTapUp = onPressed == null ? null : (_) async {
      await delay(_duration, () {
        pressed = false;
        if (!mounted) return;
        setState(() {
          if (_withTapUp != null) _withTapUp!();
          if (allowPressEffect) scale = 1.0;
        });
      });
      onPressed!();
    };
  }

  void _setOnTapCancel() {
    setState(() => pressed = false);
    _onTapCancel = () => setState(() {
      pressed = false;
      if (_withTapCancel != null) _withTapCancel!();
      if (allowPressEffect) scale = 1.0;
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

  @override
  void dispose() {
    super.dispose();
    PageCont.removeContext(context);
  }

  VoidCallback? onPressed;
  VoidCallback? onLongPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: onLongPressed,
      child: AnimatedScale(
        scale: scale,
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

  bool get isCircle => false;
  BoxShape get _boxShape => isCircle ? BoxShape.circle : BoxShape.rectangle;
  BorderRadius? get radius {
    if (isCircle) return null;
    return BorderRadius.circular(10.0.r);
  }

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

  bool get allowPressEffect => true;
  double get pressedScale => .97;

  void _setOnTapDown() {
    if (onPressed == null) return;
    _onTapDown = (_) {
      setState(() {
        if (_withTapDown != null) _withTapDown!();
        if (allowPressEffect) {
          _scale = pressedScale;
          _opacity = .1;
          _tintColor = ThemeCont.to.text;
        }
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
          if (allowPressEffect) {
            _scale = 1.0;
            _opacity = .0;
            _tintColor = Colors.transparent;
          }
        });
      });
      onPressed!();
    };
  }

  void _setOnTapCancel() {
    _onTapCancel = () => setState(() {
      if (_withTapCancel != null) _withTapCancel!();
      setState(() {
        if (allowPressEffect) {
          _scale = 1.0;
          _opacity = .0;
          _tintColor = Colors.transparent;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
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
            shape: _boxShape,
            borderRadius: radius,
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