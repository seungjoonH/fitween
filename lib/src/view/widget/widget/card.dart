import 'package:fitween/src/controller/loading.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:get/get.dart';

class FCard extends StatefulWidget {
  const FCard({
    Key? key,
    this.title,
    this.icon,
    required this.child,
    this.backgroundColor,
    this.onPressed,
    this.width,
    this.height,
    this.constraints,
    this.borderColor,
    this.borderWidth,
    this.padding,
  }) : super(key: key);

  final Widget? title;
  final Icon? icon;
  final Widget child;
  final Color? backgroundColor;
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

class _FCardState extends State<FCard> with DarkPressable {
  EdgeInsets? get padding => widget.padding
      ?? EdgeInsets.all(20.0.r);
  BoxConstraints? get constraints => widget.constraints
      ?? BoxConstraints(minHeight: 60.0.h);
  Widget get icon {
    final Color color = FTheme.comment;
    final double size = 20.0.r;

    if (widget.icon == null) {
      if (widget.onPressed != null) {
        return Icon(
          Icons.keyboard_arrow_right_outlined,
          color: color, size: size,
        );
      }
      return Container();
    }

    return Icon(
      widget.icon!.icon,
      color: color, size: size,
    );
  }
  Widget get child => Padding(
    padding: EdgeInsets.only(top: 20.0.h),
    child: widget.child,
  );

  @override
  Color get backgroundColor => widget.backgroundColor ?? FTheme.card;

  @override
  Widget buildContent(BuildContext context) {
    final radius = BorderRadius.circular(12.0.r);

    return GetBuilder<LoadingCont>(
      builder: (cont) {
        return Container(
          padding: padding,
          decoration: BoxDecoration(
            color: cont.loading
                ? cont.color
                : null,
            borderRadius: radius,
            border: widget.borderColor != null
                ? Border.all(
              color: widget.borderColor!,
              width: widget.borderWidth ?? .0,
            ) : null,
          ),
          width: widget.width ?? double.infinity,
          height: widget.height,
          constraints: constraints,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null && !cont.loading)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: widget.title!),
                      icon,
                    ],
                  ),
                ],
              ),
              if (!cont.loading) child,
            ],
          ),
        );
      },
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}

class FCollapsibleCard extends FCard {
  const FCollapsibleCard({
    super.key,
    super.title,
    super.icon,
    required super.child,
    super.backgroundColor,
    super.onPressed,
    super.width,
    super.height,
    super.constraints,
    super.borderColor,
    super.borderWidth,
    super.padding,
  });

  @override
  State<FCard> createState() => _FCollapsibleCardState();
}

class _FCollapsibleCardState extends _FCardState {
  bool _opened = true;

  @override
  Icon get icon => Icon(_opened
      ? Icons.keyboard_arrow_up
      : Icons.keyboard_arrow_down
  );

  @override
  Widget get child => _opened ? super.child : Container();

  @override
  VoidCallback? get onPressed => () {
    setState(() => _opened = !_opened);
  };
}