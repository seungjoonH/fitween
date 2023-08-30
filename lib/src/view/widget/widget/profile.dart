import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:fitween/src/view/widget/widget/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FProfileWidget extends StatefulWidget {
  const FProfileWidget({
    super.key,
    this.user,
    this.onPressed,
  });

  final FUser? user;
  final Function(FUser)? onPressed;

  @override
  State<FProfileWidget> createState() => _FProfileWidgetState();
}

class _FProfileWidgetState extends State<FProfileWidget> with DarkPressable {
  FUser get user => widget.user ?? AuthCont.logged!;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0.r),
      child: Row(
        children: [
          FBadgeWidget(
            badge: user.badge,
            backgroundColor: user.badgeColor,
          ),
          SizedBox(width: 15.0.w),
          FText(
            user.nickname,
            style: textTheme(context).titleLarge,
          ),
        ],
      ),
    );
  }

  @override
  VoidCallback? get onPressed => () => widget.onPressed!(user);
}
