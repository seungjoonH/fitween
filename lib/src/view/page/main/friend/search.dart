import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendSearchPage extends FPage {
  const FriendSearchPage({super.key});

  @override
  FPageState<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends FPageState<FriendSearchPage> {
  @override
  FriendSearchPageCont get cont => FriendSearchPageCont.to;

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(
        backPressed: cont.backPressed,
        child: FSearchField(
          controller: cont.textEditingCont,
          hintText: cont.searchHintText,
          onChanged: cont.onChanged,
        ),
      ),
      body: Obx(() {
        return Column(
          children: cont.users.map((user) {
            if (user == null) return Container();
            if (user.key == AuthCont.uid) return Container();
            return FProfileWidget(
              user: user,
              showFollowButton: true,
            );
          }).toList(),
        );
      }),
    );
  }
}
