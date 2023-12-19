import 'dart:math';

class Snowball {
  late double x;
  late double y;
  late double velocity;
  late double size;
  late double opacity;

  double get _r => Random().nextDouble();

  void _init() {
    y = _r;
    velocity = .0001 + _r * .0005;
    size = 6.0 + _r * 4.0;
    opacity = .5 + _r * .4;
  }

  Snowball.random() {
    x = -.5 + _r * 1.0;
    _init();
  }

  void next() {
    x += velocity;
    if (x > 1.0) { x = .0; _init(); }
  }
}