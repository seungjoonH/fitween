import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/friend.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tab_scaffold.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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


class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> with TickerProviderStateMixin {
  late TabController tabCont;

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      tabs: const ['전체', '라이벌', '숨김'],
      bodies: [
        FCard(
          child: Text('asdfasdf'),
        ),
        Container(),
        Container(),
      ],
    );
  }
}

