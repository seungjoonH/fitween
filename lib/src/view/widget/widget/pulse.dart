import 'dart:async';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/view/widget/button/pressable.dart';
import 'package:flutter/material.dart';

class PulseWidget extends StatefulWidget {
  const PulseWidget({
    super.key,
    this.maxScale = 1.0,
    this.minScale = .98,
    this.onPressed,
    required this.child,
  });

  final Widget child;
  final double maxScale;
  final double minScale;
  final VoidCallback? onPressed;

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget> with ScalePressable {
  bool _zoomed = false;
  late final Timer? _timer;
  final _duration = 250.ms;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(_duration, (_) => setState(() {
      if (pressed) return;
      if (_zoomed) { scale = widget.minScale; }
      else { scale = widget.maxScale; }
      _zoomed = !_zoomed;
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Stack(
      children: [
        AnimatedScale(
          duration: _duration,
          scale: scale,
          child: widget.child,
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: onPressed,
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}
