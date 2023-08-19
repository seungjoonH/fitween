import 'package:flutter/material.dart';

class EternalRotation extends StatefulWidget {
  const EternalRotation({
    Key? key,
    required this.rps,
    required this.child,
  }) : super(key: key);

  final double rps;
  final Widget child;

  @override
  State<EternalRotation> createState() => _EternalRotationState();
}

class _EternalRotationState extends State<EternalRotation> {
  double turns = .0;

  void rotateOnce() => setState(() => turns += 1.0);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), rotateOnce);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      duration: Duration(milliseconds: 1000 ~/ widget.rps),
      onEnd: rotateOnce,
      child: widget.child,
    );
  }
}
