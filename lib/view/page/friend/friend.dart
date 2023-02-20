import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/page/friend.dart';
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
    return GetBuilder<UserFriendP>(
      builder: (userP) {
        return TabScaffold(
          tabs: const ['전체', '라이벌'],
          bodies: [
            FriendListCard(
              friendInfos: userP.loggedUser.friendInfos,
              friendCollections: userP.loggedUser.friendCollections,
            ),
            FriendListCard(
              friendInfos: userP.loggedUser.rivalInfos,
              friendCollections: userP.loggedUser.rivalCollections,
            ),
          ],
        );
      }
    );
  }
}

class FriendListCard extends StatelessWidget {
  const FriendListCard({
    Key? key,
    required this.friendInfos,
    required this.friendCollections,
  }) : super(key: key);

  final List<FUserInfo> friendInfos;
  final List<FUserCollection> friendCollections;

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FText('친구 ${friendInfos.length}',
                color: FTheme.lightGrey,
              ),
              GetBuilder<FriendP>(
                builder: (friendP) {
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: FTheme.lightGrey,
                        onPressed: friendP.addFriendButtonPressed,
                      ),
                      IconButton(
                        icon: Icon(friendP.editMode ? Icons.edit : Icons.close),
                        color: FTheme.lightGrey,
                        onPressed: friendP.toggleMode,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          ListView(
            shrinkWrap: true,
            children: List.generate(
              friendInfos.length, (index) => FriendListTile(
                userInfo: friendInfos[index],
              userCollection: friendCollections[index],
              ),
            ),
          ),
        ],
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
                icon: friendP.editMode ? FIcon(
                  FIcons.swords,
                  selected: friendP.isRival(userInfo.uid!),
                  size: 20.0,
                ) : const Icon(
                  Icons.delete,
                  color: FTheme.lightGrey,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}