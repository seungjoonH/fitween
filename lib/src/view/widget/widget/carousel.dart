import 'dart:async';
import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:flutter/material.dart';

class CircularCarousel extends StatefulWidget {
  const CircularCarousel({
    super.key,
    required this.children,
    required this.width,
    this.itemSize,
    this.height,
    this.leftWidget,
    this.rightWidget,
    this.onChanged,
  });

  final List<Widget> children;
  final double width;
  final double? height;
  final double? itemSize;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Function(int)? onChanged;

  @override
  State<CircularCarousel> createState() => _CircularCarouselState();
}

class _CircularCarouselState extends State<CircularCarousel> {
  int get _length => widget.children.length;

  double get _width => widget.width;
  double get _height => _orbitHeight + _itemSize;
  double get _itemSize => widget.itemSize ?? _width * .5;
  double get _orbitWidth => _width * .6;
  double get _orbitHeight => max(widget.height ?? .001, .001);
  double get _a => _orbitWidth * .5;
  double get _b => _orbitHeight * .5;

  late double velocity;
  int get _index => (_angle / _dAngle).round();

  void _setPos(double x, double y) {
    setState(() {
      _angle = asin(x / _a);
      if (x.sign > 0 && y.sign < 0) { _angle = pi - _angle; }
      else if (x.sign < 0) {
        if (y.sign > 0) { _angle = 2 * pi + _angle; }
        else { _angle = _angle.abs() + pi; }
      }
    });
  }

  Offset _getPos(int index) {
    double angle = (_angle + _dAngle * index) % (2 * pi);
    double x = _a * sin(angle) + _width * .5;
    double y = _b * cos(angle) + _height * .5;
    return Offset(x, y);
  }

  void _moveByAngle(double dt) {
    _setPosByAngle((_angle + dt) % (2 * pi));
  }

  double _angle = .0;
  double get _dAngle => 2 * pi / _length;
  double get _nearAngle {
    double err = 2 * pi;
    late int index;
    for (int i = 0; i < _length + 1; i++) {
      double e = (_dAngle * i - _angle).abs();
      if (err < e) continue;
      err = e; index = i;
    }
    return _dAngle * index;
  }

  void _setPosByAngle(double angle) {
    double x = _a * sin(angle);
    double y = _b * cos(angle);
    _setPos(x, y);
    setState(() => _angle = angle);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _moveByAngle(details.delta.dx * .005);
  }

  void _fitPos(double angle) {
    Timer.periodic(10.ms, (timer) {
      double err = angle - _angle;
      if (err.abs() > pi) err *= -1;
      if (err.abs() < .05) {
        timer.cancel();
        _setPosByAngle(_nearAngle);
        if (widget.onChanged != null) {
          int index = _index;
          if (_index == 0) index += _length;
          widget.onChanged!(_length - index);
        }
        return;
      }
      _moveByAngle(.05 * err.sign);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    velocity = details.primaryVelocity!;
    if (velocity.abs() < 8000) { _fitPos(_nearAngle); return; }

    velocity *= .00001;

    Timer.periodic(10.ms, (timer) {
      setState(() => velocity *= .99);
      if (velocity.abs() < .01) {
        timer.cancel(); _fitPos(_nearAngle);
        return;
      }
      _moveByAngle(velocity);
    });
  }

  int _compare(_CircularCarouselEntry a, _CircularCarouselEntry b) {
    return a.pos.dy.compareTo(b.pos.dy);
  }

  List<_CircularCarouselEntry> get entries => widget
      .children.asMap().entries.map((entry) => _CircularCarouselEntry(
    pos: _getPos(entry.key),
    child: entry.value,
    size: _itemSize,
  )).toList();

  List<Widget> get _widgets {
    List<_CircularCarouselEntry> es = [...entries];
    es.sort(_compare);
    return es.map((e) => e.toWidget()).toList();
  }

  void _leftButtonPressed() {
    int next = (_index + 1) % _length;
    _fitPos(_dAngle * next);
  }

  void _rightButtonPressed() {
    int next = (_index - 1) % _length;
    _fitPos(_dAngle * next);
  }

  @override
  void initState() {
    super.initState();
    _setPos(0, _b);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Builder(
        builder: (context) {
          double left = (PageCont.size.width - _width) * .5;
          double right = left + _width;

          double leftArrowPos = left + _width * .5 - _itemSize * .75;
          double rightArrowPos = right - _width * .5 - _itemSize * .75;

          return Stack(
            children: [
              Positioned(
                left: left, top: -_orbitHeight * .5,
                child: SizedBox(
                  width: _width,
                  height: _height,
                  child: Stack(children: _widgets),
                ),
              ),
              if (widget.leftWidget != null)
              Positioned(
                left: leftArrowPos, top: _height * .4,
                child: GestureDetector(
                  onTap: _leftButtonPressed,
                  child: widget.leftWidget!,
                ),
              ),
              if (widget.rightWidget != null)
              Positioned(
                right: rightArrowPos, top: _height * .4,
                child: GestureDetector(
                  onTap: _rightButtonPressed,
                  child: widget.rightWidget!,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CircularCarouselEntry {
  late Offset pos;
  late Widget child;
  late double size;

  _CircularCarouselEntry({
    required this.pos,
    required this.child,
    required this.size,
  });

  Widget toWidget() {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: pos,
        width: size,
        height: size,
      ), child: child,
    );
  }
}