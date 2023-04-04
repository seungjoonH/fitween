import 'dart:async';

import 'package:camera/camera.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/contents/workout/solo/camera.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pausable_timer/pausable_timer.dart';

class CameraPainterView extends StatelessWidget {
  const CameraPainterView({
    Key? key,
    required this.painter,
  }) : super(key: key);

  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraP>(
      builder: (cameraP) {
        return GestureDetector(
          onScaleStart: (details) => cameraP.setInitZoom(),
          onScaleUpdate: cameraP.setZoomLevel,
          child: CustomPaint(
            foregroundPainter: painter,
            child: CameraPreview(
              cameraP.cameraController!,
            ),
          ),
        );
      },
    );
  }
}

class FloatingMessageWidget extends StatelessWidget {
  const FloatingMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutSoloCameraP>(
      builder: (battleCameraP) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FText(
                  battleCameraP.message,
                  style: textTheme.headlineMedium,
                  color: FTheme.colorA,
                  maxLines: 2,
                  bold: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CountBoxWidget extends StatefulWidget {
  const CountBoxWidget({
    Key? key,
    required this.count,
    this.onPressed,
    this.pressable = false,
  }) : super(key: key);

  final int count;
  final VoidCallback? onPressed;
  final bool pressable;

  @override
  State<CountBoxWidget> createState() => _CountBoxWidgetState();
}

class _CountBoxWidgetState extends State<CountBoxWidget> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;

  double scale = 1.0;
  Duration duration = const Duration(milliseconds: 100);
  PausableTimer? timer;

  @override
  void initState() {
    timer = PausableTimer(const Duration(milliseconds: 400), () async {
      setState(() { scale = 1.1; });
      await Future.delayed(duration, () {
        setState(() { scale = 1.0; });
        timer?..reset()..start();
      });
    });
    if (!widget.pressable) return;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CountBoxWidget oldWidget) {
    if (!oldWidget.pressable && widget.pressable) { timer?.start(); }
    else if (oldWidget.pressable && !widget.pressable) { timer?.pause(); }
    if (widget.onPressed == null) return;
    onTapDown = widget.pressable ? (_) {
      timer?.pause();
      setState(() => scale = .9);
    } : null;
    onTapUp = widget.pressable ? (_) async {
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() => scale = 1.0);
      });
      widget.onPressed!();
    } : null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: duration,
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: () {
          timer?..reset()..start();
          setState(() => scale = 1.0);
        },
        child: Container(
          width: 120.0, height: 80.0,
          decoration: BoxDecoration(
            color: widget.pressable
                ? FTheme.colorD : FTheme.darkGrey,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: FText(
              '${widget.count}',
              style: textTheme.displayLarge,
              color: FTheme.white,
              bold: true,
            ),
          ),
        ),
      ),
    );
  }
}
