import 'package:flutter/material.dart';

class FSlider<T extends num> extends StatelessWidget {
  const FSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.color,
  });

  final T value;
  final Function(T) onChanged;
  final T? min;
  final T? max;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value.toDouble(),
      onChanged: (num value) {
        if (T == int) { onChanged(value.toInt() as T); }
        else { onChanged(value.toDouble() as T); }
      },
      min: min?.toDouble() ?? .0,
      max: max?.toDouble() ?? 1.0,
      activeColor: color,
      thumbColor: color,
      inactiveColor: color?.withOpacity(.2),
    );
  }
}