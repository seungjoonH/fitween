import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:flutter/material.dart';

class FPointHistoryPage extends FPage {
  const FPointHistoryPage({super.key});

  @override
  FPageState<FPointHistoryPage> createState() => _FPointHistoryPageState();
}

class _FPointHistoryPageState extends FPageState<FPointHistoryPage> {

  @override
  FPointHistoryPageCont get cont => FPointHistoryPageCont.to;

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold();
  }

}
