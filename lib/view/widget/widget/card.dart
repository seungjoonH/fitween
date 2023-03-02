import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:get/get.dart';

class FCard extends StatefulWidget {
  FCard({
    Key? key,
    this.title,
    this.activateSeeMore = false,
    required this.child,
    this.backgroundColor = FTheme.white,
    this.onPressed,
    this.constraints,
    this.borderColor,
    EdgeInsets? padding,
  })  : padding = padding ?? EdgeInsets.all(20.0.r),
        super(key: key);

  final String? title;
  final bool activateSeeMore;
  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final BoxConstraints? constraints;
  final EdgeInsets? padding;
  final Color? borderColor;

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
    BorderRadius radius = BorderRadius.circular(12.0);

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
                width: double.infinity,
                padding: widget.padding,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: widget.borderColor != null
                      ? Border.all(color: widget.borderColor!)
                      : null,
                ),
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
                            FText(
                              widget.title!,
                              style: textTheme.titleMedium,
                              color: FTheme.darkGrey,
                              bold: true,
                            ),
                            if (widget.activateSeeMore)
                            const Icon(Icons.arrow_forward_ios, color: FTheme.lightGrey),
                          ],
                        ),
                        const SizedBox(height: 10.0),
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
