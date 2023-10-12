import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';

class PartyApplicantsPage extends FPage {
  const PartyApplicantsPage({super.key});

  @override
  FPageState<PartyApplicantsPage> createState() => _PartyApplicantsPageState();
}

class _PartyApplicantsPageState extends FPageState<PartyApplicantsPage> {
  @override
  PageCont get cont => PartyApplicantsPageCont.to;

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(),
    );
  }

}
