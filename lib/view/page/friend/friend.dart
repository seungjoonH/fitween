import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/friend.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tab_scaffold.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FTab extends StatelessWidget {
  const FTab(this.text, {
    Key? key,
    this.selected = false,
  }) : super(key: key);

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: FText(
        text,
        style: textTheme.titleLarge,
        color: selected
            ? FTheme.grey
            : FTheme.lightGrey,
      ),
    );
  }
}


class FriendPage extends StatelessWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      tabs: const ['전체', '라이벌', '숨김'],
      bodies: [
        FCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '친구 ' + '5',
                    style: TextStyle(
                      color: FTheme.lightGrey,
                    ),
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.edit),
                  )
                ],
              ),
              const FriendCard('슈비'),
              const FriendCard('하쿠나'),
              const FriendCard('영천'),
              const FriendCard('유저'),
              const FriendCard('복카이'),
            ],
          ),
        ),
        Container(),
        Container(),
      ],
    );
  }
}

class FriendCard extends StatelessWidget{
  const FriendCard(this.name,{Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /*BadgeWidget(
          badge: BadgePresenter.getBadge(controller.loggedUser.badgeId),
          size: 80.0.r,
        ),*/
        Image.asset('assets/image/badge/1000000.png', height: 48, width: 48),
        const SizedBox(width: 12.0, height: 90.0),
        FText(
          name,
          style: textTheme.labelLarge,
        ),
        Expanded(
            child: Container()
        ),
        IconButton(
          onPressed: (){},
          icon: SvgPicture.asset(
              'assets/image/icon/selected/visibility.svg',
            color: FTheme.black,
          ),
        ),
        IconButton(
          onPressed: (){},
          icon: SvgPicture.asset(
            'assets/image/icon/selected/swords.svg',
            color: FTheme.black,
          ),
        ),
      ],
    );
  }

}