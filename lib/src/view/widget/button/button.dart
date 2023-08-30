import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';

class FButton extends StatefulWidget {
  const FButton({
    super.key,
    this.text,
    this.child,
    this.style,
    this.bold = false,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.border = true,
    this.onPressed,
    this.alignment,
    this.stretch = false,
    this.padding,
  }) : assert(text == null || child == null),
        assert(stretch || alignment == null);

  final String? text;
  final Widget? child;
  final TextStyle? style;
  final bool bold;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool border;
  final VoidCallback? onPressed;
  final ButtonAlignment? alignment;
  final bool stretch;
  final EdgeInsets? padding;

  static final ancestorKey = GlobalKey();

  @override
  State<FButton> createState() => _FButtonState();
}

class _FButtonState extends State<FButton> with ScalePressable<FButton> {
  EdgeInsets get _padding => widget.padding ?? EdgeInsets.symmetric(
    horizontal: 25.0.r, vertical: 12.0.r,
  );

  @override
  Widget buildContent(BuildContext context) {
    Color textColorAlt = widget.textColor ?? FTheme.backgroundAlt;
    Color backgroundColorAlt = widget.backgroundColor ?? FTheme.text;
    Color borderColorAlt = widget.borderColor ?? FTheme.stroke;

    final style = widget.style
        ?? FTheme.bodyLarge;
    final border = widget.border
        ? Border.all(color: borderColorAlt, width: 1.0)
        : const Border();
    final radius = BorderRadius.circular(15.0.r);

    Widget? child = widget.child;
    child ??= FText(
      widget.text ?? '',
      style: style,
      color: textColorAlt,
      bold: widget.bold,
    );

    final leftPadding = widget.stretch && widget.alignment != ButtonAlignment.left;
    final rightPadding = widget.stretch && widget.alignment != ButtonAlignment.right;

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        border: border,
        borderRadius: radius,
        color: backgroundColorAlt,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leftPadding) const Expanded(child: SizedBox()),
          child,
          if (rightPadding) const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}

enum ButtonAlignment {
  left, right, center;
  CrossAxisAlignment get translate {
    return CrossAxisAlignment.values[index];
  }
}

// class FCircledButton extends StatefulWidget {
//   const FCircledButton({
//     Key? key,
//     required this.onPressed,
//     this.onLongPressed,
//     required this.child,
//     this.size = 80.0,
//     this.backgroundColor,
//   }) : super(key: key);
//
//   final VoidCallback onPressed;
//   final VoidCallback? onLongPressed;
//   final Widget child;
//   final double size;
//   final Color? backgroundColor;
//
//   @override
//   State<FCircledButton> createState() => _FCircledButtonState();
// }
//
// class _FCircledButtonState extends State<FCircledButton> {
//   Function(TapDownDetails)? onTapDown;
//   Function(TapUpDetails)? onTapUp;
//
//   double scale = 1.0;
//   Duration duration = const Duration(milliseconds: 100);
//
//   bool longPressed = false;
//
//   @override
//   void initState() {
//     onTapDown = (_) {
//       setState(() => scale = .9);
//     };
//     onTapUp = (_) async {
//       await Future.delayed(duration, () {
//         if (!mounted) return;
//         setState(() => scale = 1.0);
//       });
//       widget.onPressed();
//     };
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedScale(
//       scale: scale,
//       duration: duration,
//       child: GestureDetector(
//         onTapDown: onTapDown,
//         onTapUp: onTapUp,
//         onTapCancel: () => setState(() => scale = 1.0),
//         onLongPress: widget.onLongPressed,
//         child: Container(
//           width: widget.size.r,
//           height: widget.size.r,
//           decoration: BoxDecoration(
//             color: widget.backgroundColor,
//             shape: BoxShape.circle,
//           ),
//           padding: EdgeInsets.all(10.0.r),
//           alignment: Alignment.center,
//           child: widget.child,
//         ),
//       ),
//     );
//   }
// }
//
// class FIconButton extends StatelessWidget {
//   const FIconButton({
//     Key? key,
//     required this.icon,
//     required this.onPressed,
//     this.backgroundColor = Colors.transparent,
//   }) : super(key: key);
//
//   final FIcon icon;
//   final VoidCallback onPressed;
//   final Color? backgroundColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: backgroundColor,
//       borderRadius: BorderRadius.circular(icon.size.r),
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(icon.size.r),
//         child: Padding(
//           padding: EdgeInsets.all(10.0.r),
//           child: icon,
//         ),
//       ),
//     );
//   }
// }
