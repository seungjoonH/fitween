import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/loading.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:get/get.dart';

enum FCardPressMode { entire, icon }

class FCard extends StatefulWidget {
  const FCard({
    Key? key,
    this.title,
    this.autoIcon = true,
    this.icon,
    this.rightTopWidget,
    this.iconColor,
    this.child,
    this.backgroundWidget,
    this.backgroundColor,
    this.onPressed,
    this.pressMode = FCardPressMode.entire,
    this.width,
    this.height,
    this.constraints,
    this.borderColor,
    this.borderWidth,
    this.padding,
  }) : assert(icon == null
      || rightTopWidget == null), super(key: key);

  final Widget? title;
  final bool autoIcon;
  final Icon? icon;
  final Widget? rightTopWidget;
  final Color? iconColor;
  final Widget? child;
  final Widget? backgroundWidget;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final FCardPressMode? pressMode;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsets? padding;
  final Color? borderColor;
  final double? borderWidth;

  @override
  State<FCard> createState() => _FCardState();
}

class _FCardState extends State<FCard> with ScalePressable {
  EdgeInsets? get padding => widget.padding
      ?? EdgeInsets.all(20.0.r);
  BoxConstraints? get constraints => widget.constraints
      ?? BoxConstraints(minHeight: 60.0.h);

  @override
  bool get allowPressEffect => widget.pressMode == FCardPressMode.entire;

  Widget get icon {
    if (!widget.autoIcon) return Container();

    final Color color = widget.iconColor ?? FTheme.comment;
    final double size = 20.0.r;

    Icon rightArrowIcon = Icon(
      Icons.arrow_forward_ios,
      color: color, size: size,
    );

    VoidCallback? iconPressed = widget.pressMode == FCardPressMode.icon
        ? widget.onPressed : null;

    if (widget.icon == null) {
      if (widget.onPressed != null) {
        return FIconButton(
          onPressed: iconPressed,
          icon: rightArrowIcon,
          iconColor: color,
        );
      }
      return Container();
    }

    Icon icon = Icon(
      widget.icon!.icon,
      size: size,
      color: color,
    );

    return widget.pressMode == FCardPressMode.icon
        ? FIconButton(
      icon: icon,
      iconColor: color,
      onPressed: widget.onPressed,
    ) : SizedBox(
      width: 60.0.r, height: 60.0.r,
      child: icon,
    );
  }
  Widget get child => Padding(
    padding: widget.title == null
        ? EdgeInsets.zero
        : EdgeInsets.only(top: 20.0.h),
    child: widget.child,
  );

  Color get backgroundColor {
    if (widget.backgroundWidget != null) return Colors.transparent;
    return widget.backgroundColor ?? FTheme.card;
  }

  LoadingCont get cont => LoadingCont.to;

  Widget _buildRightTopWidget(BuildContext context) {
    if (widget.rightTopWidget == null) return icon;
    return Positioned(
      top: 10.0.r, right: 10.0.r,
      child: widget.rightTopWidget!,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final radius = BorderRadius.circular(12.0.r);
    return Obx(() => ClipRRect(
      borderRadius: radius,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.backgroundWidget != null)
          Positioned.fill(child: widget.backgroundWidget!),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: cont.loading
                      ? cont.color
                      : backgroundColor,
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
                      widget.title!,
                    if (!cont.loading) child,
                  ],
                ),
              ),
              if (!cont.loading) _buildRightTopWidget(context),
            ],
          ),
        ],
      ),
    ));
  }

  @override
  VoidCallback? get onPressed {
    if (widget.pressMode != FCardPressMode.entire) return null;
    return widget.onPressed;
  }
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

class FImageCard extends FCard {
  const FImageCard({
    super.key,
    this.imageUrl,
    this.bookmarked = false,
    super.iconColor,
    super.title,
    super.child,
    super.backgroundWidget,
    super.backgroundColor,
    super.onPressed,
    super.pressMode = FCardPressMode.entire,
    super.width,
    super.height,
    super.constraints,
    super.borderColor,
    super.borderWidth,
  });

  final String? imageUrl;
  final bool bookmarked;

  @override
  EdgeInsets? get padding => EdgeInsets.zero;

  @override
  bool get autoIcon => false;

  @override
  Widget? get rightTopWidget {
    if (!bookmarked) return super.rightTopWidget;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Icon(
          Icons.bookmark,
          size: 35.0.r,
          color: iconColor,
        ),
        Icon(
          Icons.bookmark_outline,
          size: 35.0.r,
          color: Color.alphaBlend(
            FTheme.achro95.withOpacity(.6),
            iconColor!,
          ),
        ),
      ],
    );
  }

  @override
  Widget? get title => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          if (imageUrl == null) {
            return Container(
              color: FTheme.bar,
              width: width,
              height: width * .6,
            );
          }
          return Hero(
            tag: imageUrl!,
            child: Image.asset(
              imageUrl!,
              fit: BoxFit.cover,
              width: width,
              height: width * .6,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  ImageCont.emptyAssetPath,
                  fit: BoxFit.cover,
                  width: width,
                  height: width * .6,
                );
              },
            ),
          );
        },
      ),
      Container(
        padding: EdgeInsets.fromLTRB(20.0.r, 20.0.r, 20.0.r, .0),
        child: super.title,
      ),
    ],
  );

  @override
  Widget? get child => Container(
    padding: EdgeInsets.fromLTRB(20.0.r, .0, 20.0.r, 20.0.r),
    child: super.child,
  );
}