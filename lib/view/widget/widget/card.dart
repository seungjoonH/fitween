import 'package:fitween/presenter/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:get/get.dart';

class FCard extends StatefulWidget {
  FCard({
    Key? key,
    this.title,
    this.icon,
    required this.child,
    this.backgroundColor = FTheme.white,
    this.onPressed,
    this.width,
    this.height,
    this.constraints,
    this.borderColor,
    this.borderWidth,
    EdgeInsets? padding,
  })  : padding = padding ?? EdgeInsets.all(20.0.r),
        super(key: key);

  final Widget? title;
  final Icon? icon;
  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsets? padding;
  final Color? borderColor;
  final double? borderWidth;

  @override
  State<FCard> createState() => _FCardState();
}

class _FCardState extends State<FCard> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;

  double scale = 1.0;
  double opacity = .0;
  Duration duration = const Duration(milliseconds: 100);

  @override
  void initState() {
    onTapDown = widget.onPressed == null ? null : (_) {
      setState(() {
        scale = .9; opacity = .2;
      });
    };
    onTapUp = widget.onPressed == null ? null : (_) async {
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() {
          scale = 1.0; opacity = .0;
        });
      });
      widget.onPressed!();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(12.0.r);
    return AnimatedScale(
      scale: scale,
      duration: duration,
      child: GetBuilder<LoadingP>(
        builder: (loadingP) {
          return Material(
            borderRadius: radius,
            color: loadingP.setColor(widget.backgroundColor),
            child: GestureDetector(
              onTapDown: onTapDown,
              onTapUp: onTapUp,
              onTapCancel: () => setState(() => scale = 1.0),
              child: AnimatedContainer(
                padding: widget.padding,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: widget.borderColor != null
                      ? Border.all(
                    color: widget.borderColor!,
                    width: widget.borderWidth ?? .0,
                  ) : null,
                ),
                width: widget.width ?? double.infinity,
                height: widget.height,
                duration: duration,
                constraints: widget.constraints,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null && !loadingP.loading)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: widget.title!),
                            if (widget.icon != null)
                            Icon(
                              widget.icon!.icon,
                              color: FTheme.lightGrey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                    if (!loadingP.loading) widget.child,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
