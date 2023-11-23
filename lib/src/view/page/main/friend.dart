import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendPage extends FPage {
  const FriendPage({super.key});

  @override
  FPageState<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends FPageState<FriendPage> {
  @override
  FriendPageCont get cont => FriendPageCont.to;

  Widget _buildEachFriendListTileWidget(BuildContext context, FUser friend) {
    return Obx(() => Stack(
      alignment: Alignment.centerRight,
      children: [
        FProfileWidget(
          user: friend,
          showFollowButton: cont.editMode,
          onPressed: cont.profileWidgetPressed,
          followButtonPressed: cont.followButtonPressed,
        ),
      ],
    ));
  }

  Widget _buildFriendsCardContentWidget(BuildContext context) {
    return Obx(() {
      List<FUser> friends = cont.friends;
      bool noFriends = friends.isEmpty;
      return noFriends ? Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.h),
          child: FText(
            cont.noFriendsText,
            color: ThemeCont.to.comment,
            align: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ) : Column(
        children: cont.friends.map((f) {
          return _buildEachFriendListTileWidget(context, f);
        }).toList(),
      );
    });
  }

  Widget _buildFriendsCardWidget(BuildContext context) {
    return Obx(() {
        IconData iconData = Icons.edit;

        if (cont.editMode) {
          iconData = cont.changed
              ? Icons.save : Icons.close;
        }

        return FCard(
        title: FText(
          cont.friendsCountText,
          color: ThemeCont.to.comment,
          style: ThemeCont.to.commentStyle,
        ),
        icon: Icon(iconData),
        onPressed: cont.toggleMode,
        pressMode: FCardPressMode.icon,
        child: _buildFriendsCardContentWidget(context),
      );
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return FMainScaffold(
      refreshController: RefreshController(),
      onRefresh: cont.onRefresh,
      appBar: FAppBar(
        text: cont.appBarTitle,
        actions: [
          FIconButton(
            icon: const Icon(Icons.search),
            iconColor: ThemeCont.to.text,
            onPressed: cont.friendSearchButtonPressed,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFriendsCardWidget(context),
        ],
      ),
    );
  }
}
