import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/view/widget/widget/text.dart';

class FAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FAppBar({
    Key? key,
    this.title,
    this.color,
    this.leading,
    this.actions,
  }) : super(key: key);

  final String? title;
  final Color? color;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalP>(
      builder: (controller) {
        return AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: FTheme.black),
          backgroundColor: color,
          title: FText(
            title ?? '',
            style: textTheme.headlineSmall,
            bold: true,
          ),
          leading: leading,
          actions: actions,
        );
      },
    );
  }
}

class CameraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CameraAppBar({
    Key? key,
    this.title,
    this.color,
    this.leading,
    this.actions,
  }) : super(key: key);

  final String? title;
  final Color? color;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(110.0);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalP>(
      builder: (controller) {
        return AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: FTheme.black),
          backgroundColor: color,
          title: FText(title ?? '', style: textTheme.headlineMedium),
          leading: leading,
          actions: actions,
        );
      },
    );
  }
}