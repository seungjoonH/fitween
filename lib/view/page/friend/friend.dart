import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/user.dart';
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
    return GetBuilder<UserP>(
      builder: (userP) {
        return TabScaffold(
          tabs: const ['전체', '라이벌'],
          bodies: [
            FriendListCard(friends: userP.loggedUser.friends),
            FriendListCard(friends: userP.loggedUser.rivals),
          ],
        );
      }
    );
  }
}

class FriendListCard extends StatelessWidget {
  const FriendListCard({
    Key? key,
    required this.friends,
  }) : super(key: key);

  final List<FUser> friends;

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FText('친구 ${friends.length}',
                color: FTheme.lightGrey,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: FTheme.lightGrey,
                    onPressed: () {  },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: FTheme.lightGrey,
                    onPressed: () {  },
                  ),
                ],
              ),
            ],
          ),
          ListView(
            shrinkWrap: true,
            children: friends.map((user) => FriendListTile(
              user: user,
            )).toList(),
          ),
        ],
      ),
    );
  }
}


class FriendListTile extends StatelessWidget{
  const FriendListTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final FUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          FBadgeWidget(badge: BadgePresenter.getBadge(user.badgeId)),
          const SizedBox(width: 10.0),
          Expanded(
            child: FText(
              user.nickname!,
              style: textTheme.titleMedium,
            ),
          ),
          GetBuilder<FriendP>(
            builder: (friendP) {
              return IconButton(
                onPressed: () => friendP.toggleRival(user.uid!),
                icon: FIcon(
                  FIcons.swords,
                  selected: friendP.isRival(user.uid!),
                  size: 20.0,
                ),
              );
            }
          )
        ],
      ),
    );
  }

}