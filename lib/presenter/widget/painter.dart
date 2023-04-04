import 'package:fitween/presenter/page/home/home.dart';
import 'package:flutter/material.dart';

class PainterP {
  static Size get canvasSize => Size(
    HomeP.screenSize.width,
    HomeP.screenSize.width * (4 / 3),
  );
}