import 'package:fitween/presenter/global.dart';
import 'package:fitween/view/page/home/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fitween/view/widget/widget/bottom_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: GlobalPresenter.closeBottomBar,
      child: const Scaffold(
        appBar: HomeAppBar(),
        bottomSheet: PBottomSheetBar(body: HomeView()),
      ),
    );
  }
}