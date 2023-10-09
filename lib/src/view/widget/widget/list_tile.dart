import 'package:fitween/global/theme.dart';
import 'package:fitween/src/controller/loading.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FListTile extends StatefulWidget {
  const FListTile({
    Key? key,
    this.title,
    this.tags,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPressed,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);

  final String? title;
  final List<FTag>? tags;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? trailing;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  @override
  State<FListTile> createState() => _FListTileState();
}

class _FListTileState extends State<FListTile> with DarkPressable<FListTile> {

  LoadingCont get cont => LoadingCont.to;

  EdgeInsets get padding => widget.padding ?? EdgeInsets.all(15.0.r);

  @override
  Widget buildContent(BuildContext context) {
    final radius = BorderRadius.circular(12.0.r);
    return Obx(() => ClipRRect(
      borderRadius: radius,
      child: Container(
        padding: padding,
        height: 110.0.h,
        decoration: BoxDecoration(
          color: cont.loading
              ? cont.color
              : widget.backgroundColor ?? Colors.transparent,
          borderRadius: radius,
        ),
        child: cont.loading ? Container() : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.leading != null)
            Container(
              constraints: BoxConstraints(minWidth: 30.0.w),
              padding: EdgeInsets.only(right: 10.0.w),
              child: widget.leading,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FText(
                    widget.title ?? '',
                    color: FTheme.text,
                    bold: true,
                    maxLines: 2,
                  ),
                  if (widget.subtitle != null)
                  FText(
                    widget.subtitle!,
                    color: FTheme.comment,
                    style: FTheme.bodyMedium,
                    maxLines: 3,
                  ),
                  if (widget.tags != null)
                  Row(
                    children: widget.tags?.map((FTag tag) => Padding(
                      padding: EdgeInsets.only(right: 5.0.w),
                      child: tag,
                    )).toList() ?? [],
                  ),
                ],
              ),
            ),
            if (widget.trailing != null)
              Container(
                padding: EdgeInsets.only(left: 10.0.w),
                child: Row(children: widget.trailing!),
              ),
          ],
        ),
      ),
    ));
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}
