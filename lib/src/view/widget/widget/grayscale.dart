import 'package:flutter/material.dart';

class GrayScaleWidget extends StatelessWidget {
  const GrayScaleWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const List<double> matrix = [
      .2126, .7152, .0722, .0, .0,
      .2126, .7152, .0722, .0, .0,
      .2126, .7152, .0722, .0, .0,
      .0, .0, .0, 1.0, .0,
    ];

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(matrix),
      child: child,
    );
  }
}
