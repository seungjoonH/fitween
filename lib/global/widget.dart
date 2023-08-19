import 'package:flutter/material.dart';

extension ListExtension on List<Widget> {
  List<Widget> separate(double height) {
    List<Widget> list = [];
    for (int i = 0; i < length * 2 - 1; i++) {
      if (i % 2 == 0) { list.add(this[i ~/ 2]); }
      else { list.add(SizedBox(height: height)); }
    }
    return list;
  }
}