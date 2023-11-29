import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EternalRotation extends StatefulWidget {
  const EternalRotation({
    Key? key,
    required this.rps,
    required this.child,
  }) : super(key: key);

  final double rps;
  final Widget child;

  @override
  State<EternalRotation> createState() => _EternalRotationState();
}

class _EternalRotationState extends State<EternalRotation> {
  double turns = .0;

  void rotateOnce() => setState(() => turns += 1.0);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), rotateOnce);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      duration: Duration(milliseconds: 1000 ~/ widget.rps),
      onEnd: rotateOnce,
      child: widget.child,
    );
  }
}

class GlowEffectWidget extends StatelessWidget {
  const GlowEffectWidget({
    super.key,
    this.effectOn = true,
    required this.child,
  });

  final bool effectOn;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    String asset = 'assets/image/widget/dialog/effect.svg';

    return Stack(
      alignment: Alignment.center,
      children: [
        if (effectOn)
        EternalRotation(
          rps: .3,
          child: SvgPicture.asset(
            asset,
            width: 250.0.r,
            height: 250.0.r,
          ),
        ),
        child,
      ],
    );
  }
}
