import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContentsPage extends FPage {
  const ContentsPage({super.key});

  @override
  FPageState<ContentsPage> createState() => _ContentsPageState();
}

class _ContentsPageState extends FPageState<ContentsPage> {
  @override
  ContentsPageCont get cont => ContentsPageCont.to;

  @override
  Widget buildPage(BuildContext context) {
    return FMainScaffold(
      refreshController: RefreshController(),
      appBar: FAppBar(text: cont.appBarTitle),
      onRefresh: cont.onRefresh,
    );
  }

}