import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FListTile extends StatefulWidget {
  const FListTile({
    Key? key,
    required this.title,
    this.tag,
    this.subtitle,
    this.maxLines = 2,
    this.leading,
    this.trailing,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final FTag? tag;
  final String? subtitle;
  final int maxLines;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  State<FListTile> createState() => _FListTileState();
}

class _FListTileState extends State<FListTile> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;
  VoidCallback? onTapCancel;

  double scale = 1.0;
  double opacity = .0;
  Duration duration = const Duration(milliseconds: 100);

  Color backgroundColor = Colors.transparent;

  @override
  void initState() {
    onTapDown = widget.onPressed == null ? null : (_) {
      setState(() {
        backgroundColor = FTheme.black.withOpacity(.1);
        scale = .9; opacity = .2;
      });
    };
    onTapUp = widget.onPressed == null ? null : (_) async {
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() {
          backgroundColor = Colors.transparent;
          scale = 1.0; opacity = .0;
        });
      });
      widget.onPressed!();
    };
    onTapCancel = () => setState(() {
      backgroundColor = Colors.transparent;
      scale = 1.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(12.0.r);
    return AnimatedScale(
      scale: scale,
      duration: duration,
      child: Material(
        borderRadius: radius,
        color: backgroundColor,
        child: GestureDetector(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTapCancel: onTapCancel,
          child: Container(
            padding: EdgeInsets.all(15.0.r),
            color: Colors.transparent,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: FText(widget.title, bold: true)),
                    if (widget.tag != null) widget.tag!,
                  ],
                ),
                SizedBox(height: 5.0.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.leading != null)
                    Container(
                      constraints: BoxConstraints(minWidth: 30.0.w),
                      child: widget.leading,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FText(
                            widget.subtitle ?? '',
                            color: FTheme.lightGrey,
                            style: textTheme(context).bodyMedium,
                            maxLines: widget.maxLines,
                          ),
                        ],
                      ),
                    ),
                    if (widget.trailing != null)
                    Container(
                      constraints: BoxConstraints(minWidth: 30.0.w),
                      child: widget.trailing,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
