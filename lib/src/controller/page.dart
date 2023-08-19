import 'package:flutter/material.dart';

class PageCont {
  static final List<BuildContext> _contexts = [];
  static set context(BuildContext cont) => _contexts.add(cont);
  static BuildContext get context => _contexts.last;
  static removeContext() => _contexts.removeLast();

  static late MediaQueryData mediaQuery;
  static Size get size => mediaQuery.size;
  static Orientation get orientation => mediaQuery.orientation;

  static bool get isPortrait => orientation == Orientation.portrait;
  static bool get isLandscape => orientation == Orientation.landscape;

}