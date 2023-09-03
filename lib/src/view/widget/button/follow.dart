import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    required this.user,
    this.onPressed,
    this.autoSave = true,
  });

  final FUser user;
  final Function(FUser)? onPressed;
  final bool autoSave;

  FollowCont get cont => FollowCont.to;

  Color get backgroundColor => cont.getFollowed(user.key)
      ? FTheme.background : FTheme.text;

  Color get textColor => cont.getFollowed(user.key)
      ? FTheme.text : FTheme.background;

  @override
  Widget build(BuildContext context) {
    return Obx(() => FButton(
      text: cont.getButtonText(user.key),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.r,
        vertical: 4.0.r,
      ),
      style: FTheme.bodyMedium,
      textColor: textColor,
      backgroundColor: backgroundColor,
      onPressed: () {
        cont.followButtonPressed(user.key);
        if (autoSave) cont.saveFollowingState();
        if (onPressed != null) onPressed!(user);
      },
    ));
  }
}
