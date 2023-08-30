import 'package:fitween/global/global.dart';
import 'package:fitween/global/theme.dart';
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

  @override
  void initState() {
    super.initState();
    cont.initState();
  }

  Widget _buildEachFriendListTileWidget(BuildContext context, FUser friend) {
    return Obx(() => Stack(
      alignment: Alignment.centerRight,
      children: [
        FProfileWidget(
          user: friend,
          onPressed: cont.profileWidgetPressed,
        ),
        if (cont.editMode)
        FIconButton(
          icon: const Icon(Icons.delete),
          size: 50.0.r,
          onPressed: () => cont.friendDeleteButtonPressed(friend),
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
            color: FTheme.comment,
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
    return Obx(() => FCard(
      title: FText(
        cont.friendsCountText,
        color: FTheme.comment,
        style: FTheme.commentStyle,
      ),
      icon: Icon(cont.editMode ? Icons.clear : Icons.edit),
      onPressed: cont.toggleMode,
      pressMode: FCardPressMode.icon,
      child: _buildFriendsCardContentWidget(context),
    ));
  }

  @override
  Widget buildPage(BuildContext context) {
    return FMainScaffold(
      refreshController: RefreshController(),
      onRefresh: cont.init,
      appBar: FAppBar(
        text: cont.appBarTitle,
        actions: [
          FIconButton(
            icon: const Icon(Icons.person_add_alt_1),
            iconColor: FTheme.text,
            onPressed: () {},
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
