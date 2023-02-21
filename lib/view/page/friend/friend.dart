import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/notification.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:fitween/presenter/page/friend.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/icon.dart';
import 'package:fitween/view/widget/widget/tab_scaffold.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      tabs: const ['전체', '라이벌'],
      bodies: List.generate(2, (index) {
        bool isRival = index == 1;
        return Column(
          children: [
            FriendNotificationCard(isRival: isRival),
            FriendListCard(isRival: isRival),
          ],
        );
      }),
      action: GetBuilder<FriendP>(
        builder: (friendP) {
          return IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: friendP.addFriendButtonPressed,
          );
        },
      ),
    );
  }
}

class FriendNotificationCard extends StatelessWidget {
  const FriendNotificationCard({
    Key? key,
    required this.isRival,
  }) : super(key: key);

  final bool isRival;

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserNotificationP>();

    return StreamBuilder<DocumentSnapshot>(
      stream: UserNotificationP.collection
          .doc(userP.loggedUser.uid).snapshots(),
      builder: (context, snapshot) {
        var json = snapshot.data?.data() as Map<String, dynamic>?;
        if (json == null) return Container();
        FUserNotification user = FUserNotification.fromJson(json);
        Map<String, dynamic> userData = isRival
            ? user.rivalData : user.friendData;

        if (userData.isEmpty) return Container();
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FCard(
            child: Column(
              children: userData.values.map((friend) => NotificationListTile(
                isRival: isRival, userData: friend,
              )).toList(),
            ),
          ),
        );
      },
    );
  }
}

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    Key? key,
    required this.isRival,
    required this.userData,
  }) : super(key: key);

  final bool isRival;
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(
      vertical: 8.0, horizontal: 16.0,
    );

    return Row(
      children: [
        FBadgeWidget(badge: BadgePresenter.getBadge(userData['badgeId'])),
        const SizedBox(width: 10.0),
        Expanded(
          child: FText(
            userData['nickname'],
            style: textTheme.titleMedium,
          ),
        ),
        GetBuilder<FriendP>(
          builder: (friendP) {
            return Row(
              children: [
                FButton(
                  padding: padding, text: '거절',
                  onPressed: () => friendP.rejectButtonPressed(userData['uid'], isRival),
                  backgroundColor: FTheme.lightGrey,
                ),
                const SizedBox(width: 8.0),
                FButton(
                  padding: padding, text: '수락',
                  onPressed: () => friendP.acceptButtonPressed(userData['uid'], isRival),
                ),
              ],
            );
          }
        ),
      ],
    );
  }
}


class FriendListCard extends StatelessWidget {
  const FriendListCard({
    Key? key,
    this.isRival = false,
  }) : super(key: key);

  final bool isRival;

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: GetBuilder<UserFriendP>(
        builder: (userP) {
          return Column(
            children: [
              GetBuilder<FriendP>(
                builder: (friendP) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FText('${isRival ? '라이벌' : '친구'} ${userP.loggedUser.friendInfos.length}',
                        color: FTheme.lightGrey,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: friendP.editMode ? FTheme.darkGrey : FTheme.lightGrey,
                        onPressed: friendP.toggleMode,
                      ),
                    ],
                  );
                },
              ),
              ListView(
                shrinkWrap: true,
                children: List.generate(
                  userP.loggedUser.friendInfos.length, (index) => FriendListTile(
                    userInfo: userP.loggedUser.friendInfos[index],
                    userCollection: userP.loggedUser.friendCollections[index],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class FriendListTile extends StatelessWidget{
  const FriendListTile({
    Key? key,
    required this.userInfo,
    required this.userCollection,
  }) : super(key: key);

  final FUserInfo userInfo;
  final FUserCollection userCollection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          FBadgeWidget(badge: BadgePresenter.getBadge(userCollection.badgeId)),
          const SizedBox(width: 10.0),
          Expanded(
            child: FText(
              userInfo.nickname!,
              style: textTheme.titleMedium,
            ),
          ),
          GetBuilder<FriendP>(
            builder: (friendP) {
              return IconButton(
                onPressed: () => friendP.friendInteractButtonPressed(userInfo.uid!),
                icon: friendP.editMode ? const Icon(
                  Icons.disabled_by_default_rounded,
                  color: FTheme.darkGrey,
                ) : FIcon(
                  FIcons.swords,
                  selected: friendP.isRival(userInfo.uid!),
                  size: 20.0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}