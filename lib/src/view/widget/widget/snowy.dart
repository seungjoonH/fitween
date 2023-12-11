import 'dart:async';
import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:flutter/material.dart';

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
    size = 5.0 + _r * 4.0;
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

class SnowyBackground extends StatefulWidget {
  const SnowyBackground({super.key});

  @override
  State<SnowyBackground> createState() => _SnowyBackgroundState();
}

class _SnowyBackgroundState extends State<SnowyBackground> {
  List<Snowball> _snowballs = [];

  void _generate() => setState(() {
    _snowballs = List.generate(50, (_) => Snowball.random());
    _startSnow();
  });

  late Timer? _timer;

  void _startSnow() {
    _timer = Timer.periodic(10.ms, (_) => _snow());
  }

  void _snow() {
    setState(() { for (Snowball ball in _snowballs) { ball.next(); } });
  }

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.biggest.width;
        double height = constraints.biggest.height;
        return Stack(
          children: _snowballs.map((snow) => Positioned(
            left: width * snow.y, top: height * snow.x,
            child: Container(
              width: snow.size,
              height: snow.size,
              decoration: BoxDecoration(
                color: ThemeCont.achro100.withOpacity(snow.opacity),
                shape: BoxShape.circle,
              ),
            ),
          )).toList(),
        );
      }
    );
  }
}
