import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChallengePage extends FPage {
  const ChallengePage({super.key});

  @override
  FPageState<ChallengePage> createState() => _ChallengePageState();

}

class _ChallengePageState extends FPageState<ChallengePage> {
  @override
  ChallengePageCont get cont => ChallengePageCont.to;

  Widget _buildMyPartiesWidget(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Row(
            children: FType.activeValues.map((type) {
              Party? party = cont.getPartyByType(type);
              return PartyWidget(
                type: type,
                party: party,
                onPressed: () => cont.partyWidgetPressed(type),
              );
            }).separateW(width: 10.0.w),
          ),
          SizedBox(width: 10.0.w),
          PartyHistoryWidget(onPressed: cont.partyHistoryButtonPressed),
        ],
      ),
    ));
  }

  Widget _buildContentWidget(BuildContext context, FType type) {
    return Obx(() {
      List<Challenge> challenges = cont.challengesByType(type);
      List<Widget> contents = [];

      contents.assignAll(challenges.isEmpty
          ? [const ChallengeCard()]
          : challenges.map((c) {
        return ChallengeCard(
          challenge: c,
          bookmarked: cont.isBookmarkedChallenge(c),
          onPressed: () => cont.challengeCardPressed(c),
        );
      }).separateH(height: 20.0.h)
      );

      return SingleChildScrollView(
        child: Column(children: contents),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return FRefreshScaffold(
      refreshController: cont.refreshCont,
      onRefresh: cont.onRefresh,
      appBar: FAppBar(
        text: cont.appBarTitle,
        actions: const [
          FIconButton(
            icon: Icon(Icons.search),
            onPressed: FRoute.toPartySearch,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMyPartiesWidget(context),
          SizedBox(height: 20.0.h),
          Obx(() => FTabViewWidget(
            selectedIndex: cont.selectedType.index - 1,
            tabs: FType.activeValues.map((type) {
              return FTabData(
                index: type.index - 1,
                text: type.locale.capitalize!,
                color: type.color,
                content: _buildContentWidget(context, type),
              );
            }).toList(),
            contentHeight: PageCont.size.height * .55,
            onChanged: (i) => cont.changeType(FType.values[i + 1]),
          )),
        ],
      ),
    );
  }
}
