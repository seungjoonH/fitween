import 'package:flutter/material.dart';

extension IterableWidgetExtension on Iterable<Widget> {
  List<Widget> separateW({double? width, Widget? separator}) {
    List<Widget> list = [];
    for (int i = 0; i < length * 2 - 1; i++) {
      if (i % 2 == 0) { list.add(toList()[i ~/ 2]); }
      else { list.add(separator ?? SizedBox(width: width)); }
    }
    return list;
  }
  List<Widget> separateH({double? height, Widget? separator}) {
    List<Widget> list = [];
    for (int i = 0; i < length * 2 - 1; i++) {
      if (i % 2 == 0) { list.add(toList()[i ~/ 2]); }
      else { list.add(separator ?? SizedBox(height: height)); }
    }
    return list;
  }
}