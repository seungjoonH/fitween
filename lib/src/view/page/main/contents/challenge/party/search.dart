import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
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

  Widget _buildTypeButtonWidget(BuildContext context, FType type) {
    return DarkPressableWidget(
      onPressed: () => cont.updateTypeState(type),
      child: Row(
        children: [
          Checkbox(
            value: cont.isActive(type),
            onChanged: (_) => cont.updateTypeState(type),
            activeColor: type.color,
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0.w),
            child: FText(
              type.locale,
              color: type.color,
              bold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilterWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: FType.activeValues
          .map((type) => _buildTypeButtonWidget(context, type))
          .separateW(width: 10.0.w),
    );
  }

  Widget _buildPartyWidget(BuildContext context, Party party) {
    PartySearchedType? type = cont.getSearchedType(party.key);
    if (type == null) return Container();
    return Obx(() => PartySearchedListTile(
      party: party,
      keyword: cont.keyword,
      searchedType: type,
      onPressed: () => cont.partyListTilePressed(party),
    ));
  }

  Widget _buildSearchedPartyWidget(BuildContext context) {
    if (cont.parties.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: FTheme.bar, width: 1.0.r),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        padding: EdgeInsets.all(30.0.r),
        margin: EdgeInsets.only(top: 10.0.h),
        alignment: Alignment.center,
        child: FText(
          cont.notFoundText,
          color: FTheme.bar,
          style: FTheme.titleMedium,
        ),
      );
    }

    return Column(
      children: cont.parties
          .map((party) => _buildPartyWidget(context, party))
          .separateH(height: 10.0.h),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() => Column(
      children: [
        _buildTypeFilterWidget(context),
        SizedBox(height: 10.0.h),
        SingleChildScrollView(
          child: _buildSearchedPartyWidget(context),
        ),
      ],
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
