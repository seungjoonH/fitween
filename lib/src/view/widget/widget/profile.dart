import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/button/follow.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:fitween/src/view/widget/widget/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FProfileWidget extends StatefulWidget {
  const FProfileWidget({
    super.key,
    this.user,
    this.showFollowButton = false,
    this.showMeTag = false,
    this.onPressed,
    this.followButtonPressed,
  });

  final FUser? user;
  final Function(FUser)? onPressed;
  final bool showFollowButton;
  final bool showMeTag;
  final Function(FUser)? followButtonPressed;

  @override
  State<FProfileWidget> createState() => _FProfileWidgetState();
}

class _FProfileWidgetState extends State<FProfileWidget> with DarkPressable {
  FUser get user => widget.user ?? AuthCont.logged!;
  bool get isMe => user.key == AuthCont.logged!.key;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0.r),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Row(
            children: [
              FBadgeWidget(
                badge: user.badge,
                backgroundColor: user.badgeColor,
              ),
              FText(
                user.nickname,
                style: textTheme(context).titleMedium,
              ),
              if (widget.showMeTag && isMe) const MeTag(),
            ].separateW(width: 10.0.w),
          ),
          if (widget.showFollowButton)
          FollowButton(
            user: user,
            onPressed: widget.followButtonPressed,
          ),
        ],
      ),
    );
  }

  @override
  VoidCallback? get onPressed {
    if (widget.onPressed == null) return null;
    return () => widget.onPressed!(user);
  }
}

class FProfilePinWidget extends StatelessWidget {
  const FProfilePinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

