import 'package:fitween/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpeechBubbleWidget extends StatelessWidget {
  const SpeechBubbleWidget({
    super.key,
    this.backgroundColor,
    this.child,
  });

  final Color? backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SpeechBubblePainter(
        color: backgroundColor,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0.r, 5.0.r, 5.0.r, 15.0.r),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final Color? color;
  final double? borderRadius;

  SpeechBubblePainter({
    this.color,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Color backgroundColor = color ?? ThemeCont.colorA;
    Paint fillPaint = Paint()..color = backgroundColor.withOpacity(.8);
    Paint borderPaint = Paint()
      ..color = ThemeCont.achro95
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0.r;

    double nW = 5.0.w;
    double nH = 10.0.h;
    double r = 5.0.r;

    double w = size.width;
    double h = size.height;

    Path path = Path()
      ..moveTo(w / 2, h)
      ..lineTo((w + nW) / 2, h - nH)
      ..lineTo(w - r, h - nH)
      ..quadraticBezierTo(w, h - nH, w, h - nH - r)
      ..lineTo(w, r)
      ..quadraticBezierTo(w, 0, w - r, 0)
      ..lineTo(r, 0)
      ..quadraticBezierTo(0, 0, 0, r)
      ..lineTo(0, h - nH - r)
      ..quadraticBezierTo(0, h - nH, r, h - nH)
      ..lineTo((w - nW) / 2, h - nH)
      ..lineTo(w / 2, h)
      ..close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}