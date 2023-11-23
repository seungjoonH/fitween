import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

class WeightGuidePage extends FPage {
  const WeightGuidePage({super.key});

  @override
  FPageState<WeightGuidePage> createState() => _WeightGuidePageState();
}

class _WeightGuidePageState extends FPageState<WeightGuidePage> {
  @override
  WeightGuidePageCont get cont => WeightGuidePageCont.to;

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(),
    );
  }
}
