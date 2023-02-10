import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RAnimation extends StatelessWidget {
  const RAnimation({Key? key,
    required this.rName,
    required this.abName,
    required this.aName,
    this.fit = BoxFit.fitWidth,
  }) : super(key: key);

  final String rName;
  final String abName;
  final String aName;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(rName,
      artboard: abName,
      animations: [aName],
      fit: fit,
    );
  }
}
