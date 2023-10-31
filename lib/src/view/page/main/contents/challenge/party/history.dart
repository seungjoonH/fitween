import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PartyHistoryPage extends FPage {
  const PartyHistoryPage({super.key});

  @override
  FPageState<PartyHistoryPage> createState() => _PartyHistoryPageState();
}

class _PartyHistoryPageState extends FPageState<PartyHistoryPage> {
  @override
  PartyHistoryPageCont get cont => PartyHistoryPageCont.to;


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
              type.localeShort,
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

  Widget _buildBody(BuildContext context) {
    return Obx(() => Column(
      children: [
        _buildTypeFilterWidget(context),
        SizedBox(height: 20.0.h),
        Column(
          children: cont.parties
              .map((party) => PartyListTile(party: party))
              .separateH(height: 20.0.h),
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
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }
}
