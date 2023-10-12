import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PartySearchPage extends FPage {
  const PartySearchPage({super.key});

  @override
  FPageState<PartySearchPage> createState() => _PartySearchPageState();
}

class _PartySearchPageState extends FPageState<PartySearchPage> {
  @override
  PartySearchPageCont get cont => PartySearchPageCont.to;

  Widget _buildPartyWidget(BuildContext context, Party party) {
    PartySearchedType? type = cont.getSearchedType(party.key);
    if (type == null) return Container();
    return Obx(() => PartySearchedListTile(
      party: party,
      keyword: cont.keyword,
      searchedType: type,
    ));
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      child: Column(
        children: cont.parties
            .map((party) => _buildPartyWidget(context, party))
            .separateH(height: 10.0.h),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(
        child: FSearchField(
          controller: cont.textEditingCont,
          hintText: cont.searchHintText,
          onChanged: cont.onChanged,
        ),
      ),
      body: _buildBody(context),
    );
  }

}
