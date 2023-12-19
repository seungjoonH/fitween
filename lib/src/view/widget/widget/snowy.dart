import 'dart:async';
import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnowyBackground extends StatefulWidget {
  const SnowyBackground({super.key});

  @override
  State<SnowyBackground> createState() => _SnowyBackgroundState();
}

class _SnowyBackgroundState extends State<SnowyBackground> {
  SnowyBackgroundCont cont = SnowyBackgroundCont.to;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // double width = constraints.biggest.width;
        // double height = constraints.biggest.height;
        double width = PageCont.size.width;
        double height = PageCont.size.height;
        return Obx(() => Stack(
          children: cont.snowballs.map((snow) {
            return Positioned(
              left: width * snow.y,
              top: height * snow.x,
              child: Container(
                width: snow.size,
                height: snow.size,
                decoration: BoxDecoration(
                  color: ThemeCont.achro100.withOpacity(snow.opacity),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }).toList(),
        ));
      }
    );
  }
}
