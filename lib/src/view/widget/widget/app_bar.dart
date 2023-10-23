import 'package:fitween/route.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:fitween/global/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FAppBar extends AppBar {
  FAppBar({
    super.key,
    this.text,
    this.child,
    super.leading,
    super.actions,
    this.textColor,
    this.backPressed,
  });

  final String? text;
  final Widget? child;
  final Color? textColor;
  final VoidCallback? backPressed;

  @override
  double? get elevation => .0;

  @override
  Widget? get title {
    assert(text == null || child == null);
    if (text != null) {
      return FText(
        text!,
        style: FTheme.headlineMedium,
        color: textColor ?? FTheme.text,
      );
    }
    return child ?? Container();
  }

  @override
  Widget? get leading {
    if (FRoute.previousPage == null) return null;
    VoidCallback onPressed = backPressed ?? Get.back;
    return FIconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

  @override
  Color? get backgroundColor => Colors.transparent;
}



class FPointAppBar extends FAppBar {
  FPointAppBar({
    super.key,
    super.text,
    super.backPressed,
  });

  @override
  List<Widget>? get actions => [
    Padding(
      padding: EdgeInsets.only(right: 10.0.w),
      child: const FPointAmountWidget(onPressed: FRoute.toFPoint),
    ),
  ];
}

//
// class FAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const FAppBar({
//     Key? key,
//     this.title,
//     this.textColor,
//     this.leading,
//     this.actions,
//     this.backColor = FTheme.grey,
//   }) : super(key: key);
//
//   final String? title;
//   final Color? textColor;
//   final Widget? leading;
//   final List<Widget>? actions;
//   final Color? backColor;
//
//   @override
//   Size get preferredSize => const Size.fromHeight(60.0);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: AppBar(
//         elevation: 0.0,
//         title: FText(
//           title ?? '',
//           style: FTheme.headlineSmall,
//           bold: true,
//           color: textColor,
//         ),
//         leading: leading,
//         actions: actions,
//       ),
//     );
//   }
// }

// class CameraAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CameraAppBar({
//     Key? key,
//     this.title,
//     this.color,
//     this.leading,
//     this.actions,
//   }) : super(key: key);
//
//   final String? title;
//   final Color? color;
//   final Widget? leading;
//   final List<Widget>? actions;
//
//   @override
//   Size get preferredSize => const Size.fromHeight(110.0);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0.0,
//       iconTheme: IconThemeData(color: FTheme.black),
//       backgroundColor: color,
//       title: FText(title ?? '', style: FTheme.headlineMedium),
//       leading: leading,
//       actions: actions,
//     );
//   }
// }