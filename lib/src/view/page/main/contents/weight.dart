import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

class WeightPage extends FPage {
  const WeightPage({super.key});

  @override
  FPageState<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends FPageState<WeightPage> {
  @override
  PageCont get cont => ChallengePageCont.to;

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(),
    );
  }
}
