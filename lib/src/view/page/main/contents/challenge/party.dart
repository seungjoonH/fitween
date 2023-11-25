import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
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
  LoadingCont get loadingCont => LoadingCont.to;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return FAppBar(
      text: cont.appBarTitle,
      actions: [
        Obx(() {
          if (!cont.isLeader) return Container();
          return FIconButton(
            icon: const Icon(Icons.people_alt),
            notifications: cont.applicantCount,
            onPressed: cont.partyApplicantButtonPressed,
          );
        }),
      ],
    );
  }

  Widget _buildProgressCardWidget(BuildContext context) {
    return FCard(
      title: FText(
        cont.progressCardTitle,
        style: ThemeCont.to.cardTitleStyle,
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
          style: ThemeCont.to.titleSmall,
          color: ThemeCont.to.comment,
        ),
        SizedBox(height: 10.0.h),
        FLinearPercentIndicator(
          percent: cont.percent,
          height: 100.0.h,
          radius: 20.0.r,
          progressColor: cont.partyColor,
          backgroundColor: ThemeCont.to.background,
          animation: true,
        ),
        FText(
          cont.progressText,
          style: ThemeCont.to.titleMedium,
          bold: cont.party!.completed,
          color: cont.party!.completed
              ? cont.partyColor
              : ThemeCont.to.text,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Row(
                      children: [
                        FProfileWidget(user: member, showMeTag: true),
                        if (isLeader)
                        FTag(
                          backgroundColor: cont.party!.type.color,
                          child: Icon(
                            Icons.flag,
                            color: ThemeCont.achro95,
                            size: 16.0.r,
                          ),
                        ),
                      ],
                    ),
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
                      style: ThemeCont.to.bodySmall,
                      highlightStyle: ThemeCont.to.titleSmall,
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
          color: ThemeCont.to.comment,
          height: 20.0.h,
        ),
        FCopyButton(text: cont.party!.key),
        SizedBox(height: 10.0.h),
        FText(
          cont.shareText,
          style: ThemeCont.to.bodyLarge,
          align: TextAlign.center,
          color: ThemeCont.to.outline,
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
              style: ThemeCont.to.titleSmall,
              color: ThemeCont.to.comment,
            ),
            if ( cont.isLeader && !cont.isOnly && cont.party!.isProgressing)
            FIconButton(
              icon: const Icon(Icons.settings),
              size: 35.0,
              iconColor: ThemeCont.to.comment,
              onPressed: cont.memberSettingButtonPressed,
            ),
          ].separateW(width: 5.0.r),
        ),
        SizedBox(height: 20.0.h),
        _buildMembersProgressIndicatorWidget(context),
        if (!cont.party!.isFull && cont.party!.isProgressing)
        _buildCopyButtonWidget(context),
      ],
    ));
  }

  Widget _buildCompleteButtonWidget(BuildContext context) {
    return FPointButton(
      amount: cont.point,
      finished: cont.party!.completed,
      onPressed: cont.completeButtonPressed,
    );
  }

  Widget _buildFinishButtonWidget(BuildContext context) {
    return FButton(
      text: cont.finishText,
      stretch: true,
      onPressed: cont.finishButtonPressed,
    );
  }

  Widget _buildGiveUpButtonWidget(BuildContext context) {
    return FButton(
      text: cont.giveUpText,
      stretch: true,
      textColor: ThemeCont.achro95,
      backgroundColor: ThemeCont.error,
      onPressed: cont.giveUpButtonPressed,
    );
  }

  Widget _buildApplyButtonWidget(BuildContext context) {
    return FButton(
      text: cont.applyButtonText,
      stretch: true,
      backgroundColor: ThemeCont.to.selected,
      onPressed: cont.applyButtonPressed,
    );
  }

  Widget _buildCancelButtonWidget(BuildContext context) {
    return FButton(
      text: cont.cancelButtonText,
      stretch: true,
      backgroundColor: ThemeCont.to.selected,
      onPressed: cont.cancelButtonPressed,
    );
  }

  Widget _buildDisabledButtonWidget(BuildContext context) {
    return FButton(
      text: cont.applyButtonText,
      stretch: true,
      backgroundColor: ThemeCont.to.unselected,
      onPressed: cont.disabledButtonPressed,
    );
  }

  Widget _buildButtonWidget(BuildContext context) {
    return Obx(() {
      String myUid = AuthCont.logged!.key;

      if (cont.party!.finished) return Container();

      if (cont.party!.isMember(myUid)) {
        if (cont.party!.completed) {
          return _buildCompleteButtonWidget(context);
        }

        if (cont.party!.over) {
          return _buildFinishButtonWidget(context);
        }

        return _buildGiveUpButtonWidget(context);
      }

      if (cont.party!.isApplied(myUid)) {
        return _buildCancelButtonWidget(context);
      }

      if (cont.hasSameTypeOfAppliedParty
          || cont.hasSameTypeOfProgressingParty) {
        return _buildDisabledButtonWidget(context);
      }

      return _buildApplyButtonWidget(context);
    });
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.party == null) return Container();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_red_eye,
                color: ThemeCont.to.comment,
              ),
              SizedBox(width: 5.0.r),
              FText(
                cont.party!.views.localizing(),
                color: ThemeCont.to.comment,
              ),
            ],
          ),
          SizedBox(height: 10.0.h),
          Column(
            children: [
              PartyCard(
                party: cont.party,
                titleController: cont.partyTitleCont,
                titleEditMode: cont.partyTitleEditMode,
                onTitleChanged: cont.onTitleFieldChanged,
                toggleTitleMode: cont.toggleTitleMode,
              ),
              _buildProgressCardWidget(context),
              if (!loadingCont.loading)
              _buildButtonWidget(context),
            ].separateH(height: 20.0.h),
          ),
        ],
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
      appBar: _buildAppBar(context),
      height: PageCont.size.height * 1.8,
      body: _buildBody(context),
    );
  }
}