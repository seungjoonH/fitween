import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FUserWaterDropWidget extends StatelessWidget {
  const FUserWaterDropWidget({
    super.key,
    required this.user,
    this.size,
    this.color,
  });

  final FUser user;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    double sizeAlt = size ?? 30.0.r;
    double padding = 8.0.r;
    Color? colorAlt = color ?? ThemeCont.to.outline;

    return SizedBox(
      width: sizeAlt * 2.0 + padding,
      height: sizeAlt + padding * 2,
      child: Stack(
        children: [
          Positioned.fill(
            left: sizeAlt - padding,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(color: colorAlt),
            ),
          ),
          Positioned(
            left: .0,
            child: ScalePressableWidget(
              onPressed: () => FriendCont.to.showFriendInfoDialog(user),
              child: Stack(
                children: [
                  Container(
                    width: sizeAlt + padding * 2,
                    height: sizeAlt + padding * 2,
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: colorAlt,
                      shape: BoxShape.circle,
                    ),
                    child: FBadgeWidget(
                      badge: user.badge,
                      backgroundColor: user.badgeColor,
                      size: sizeAlt,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    double w = size.width;
    double h = size.height;

    path.moveTo(0, h / 9);
    path.lineTo(w, h / 2);
    path.lineTo(0, h * 8 / 9);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
