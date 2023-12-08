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
    this.followed,
    this.autoSave = true,
  });

  final FUser user;
  final Function(FUser)? onPressed;
  final bool? followed;
  final bool autoSave;

  FollowCont get cont => FollowCont.to;

  bool get _followed => followed ?? cont.getFollowed(user.key);

  Color get backgroundColor => _followed
      ? ThemeCont.to.background
      : ThemeCont.to.text;

  Color get textColor => _followed
      ? ThemeCont.to.text
      : ThemeCont.to.background;

  @override
  Widget build(BuildContext context) {
    return Obx(() => FButton(
      text: cont.getButtonText(_followed),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.r,
        vertical: 4.0.r,
      ),
      style: ThemeCont.to.bodySmall,
      textColor: textColor,
      backgroundColor: backgroundColor,
      onPressed: () {
        if (onPressed == null) {
          cont.followButtonPressed(user.key);
          return;
        }
        onPressed!(user);
      },
    ));
  }
}
