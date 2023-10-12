import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PartyPage extends FPage {
  const PartyPage({super.key});

  @override
  FPageState<PartyPage> createState() => _PartyPageState();
}

class _PartyPageState extends FPageState<PartyPage> {
  @override
  PartyPageCont get cont => PartyPageCont.to;

  Widget _buildProgressCardWidget(BuildContext context) {
    return FCard(
      title: FText(
        cont.progressCardTitle,
        style: FTheme.cardTitleStyle,
      ),
      child: Column(
        children: [
          _buildEntireProgressIndicatorWidget(context),
          SizedBox(height: 20.0.h),
          _buildProgressRankingWidget(context),
        ],
      ),
    );
  }

  Widget _buildEntireProgressIndicatorWidget(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FText(
          cont.entireProgressText,
          style: FTheme.titleSmall,
          color: FTheme.comment,
        ),
        SizedBox(height: 10.0.h),
        FLinearPercentIndicator(
          percent: cont.percent,
          height: 100.0.h,
          radius: 20.0.r,
          progressColor: cont.partyColor,
          backgroundColor: FTheme.background,
          animation: true,
        ),
        FText(
          cont.progressText,
          style: FTheme.titleMedium,
          bold: cont.party!.completed,
          color: cont.party!.completed
              ? cont.partyColor
              : FTheme.text,
        ),
      ],
    ));
  }

  Widget _buildMembersProgressIndicatorWidget(BuildContext context) {
    return Obx(() => Column(
      children: cont.members.map((member) {
        bool isLeader = member.key == cont.party!.leaderUid;
        return DarkPressableWidget(
          onPressed: () => cont.memberTilePressed(member),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            color: isLeader
                ? Colors.transparent
                : cont.party!.type.color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    FProfileWidget(user: member, showMeTag: true),
                    Transform.rotate(
                      angle: cont.getRank(member.key) < 3 ? -pi / 4 : 0,
                      child: RankIcon(rank: cont.getRank(member.key)),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: MemberProgressTextMode.values.map((mode) => AnimatedOpacity(
                    opacity: cont.mode == mode ? 1.0 : .0,
                    duration: 300.ms,
                    child: FTexts(
                      cont.getMemberProgressText(member.key, mode),
                      style: FTheme.bodySmall,
                      highlightStyle: FTheme.titleSmall,
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        );
      }).separateH(height: 10.0.h),
    ));
  }

  Widget _buildCopyButtonWidget(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: FTheme.comment,
          height: 20.0.h,
        ),
        FCopyButton(text: cont.party!.key),
        SizedBox(height: 10.0.h),
        FText(
          cont.shareText,
          style: FTheme.bodyLarge,
          align: TextAlign.center,
          color: FTheme.outline,
          maxLines: 0,
        ),
      ],
    );
  }

  Widget _buildProgressRankingWidget(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FText(
              cont.memberCountText,
              style: FTheme.titleSmall,
              color: FTheme.comment,
            ),
            if (cont.isLeader && !cont.isOnly)
            FIconButton(
              icon: const Icon(Icons.settings),
              size: 35.0.r,
              iconColor: FTheme.comment,
              onPressed: cont.memberSettingButtonPressed,
            ),
          ].separateW(width: 5.0.r),
        ),
        SizedBox(height: 20.0.h),
        _buildMembersProgressIndicatorWidget(context),
        if (!cont.party!.isFull)
        _buildCopyButtonWidget(context),
      ],
    ));
  }

  Widget _buildCompleteButtonWidget(BuildContext context) {
    return FPointButton(
      amount: cont.point,
      finished: cont.party!.completed,
      onPressed: (){}//cont.completeButtonPressed,
    );
  }

  Widget _buildGiveUpButtonWidget(BuildContext context) {
    return FButton(
      text: cont.giveUpText,
      stretch: true,
      backgroundColor: FTheme.error,
      onPressed: cont.giveUpButtonPressed,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.party == null) return Container();
      return Column(
        children: [
          PartyCard(
            party: cont.party,
            titleController: cont.partyTitleCont,
            titleEditMode: cont.partyTitleEditMode,
            onTitleChanged: cont.onTitleFieldChanged,
            toggleTitleMode: cont.toggleTitleMode,
          ),
          _buildProgressCardWidget(context),
          cont.party!.completed
              ? _buildCompleteButtonWidget(context)
              : _buildGiveUpButtonWidget(context),
        ].separateH(height: 20.0.h),
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
      refreshController: RefreshController(),
      onRefresh: cont.onRefresh,
      appBar: FAppBar(
        text: cont.appBarTitle,
        actions: [
          FIconButton(
            icon: const Icon(Icons.people_alt),
            onPressed: FRoute.toPartyApplicants,
          ),
        ],
      ),
      height: PageCont.size.height * 1.6,
      body: _buildBody(context),
    );
  }
}