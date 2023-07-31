import 'dart:async';
import 'dart:math';

import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/class/database/battle.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/class/json/challenge.dart';
import 'package:fitween/model/class/json/level.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/model/enum/workout.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/json/challenge.dart';
import 'package:fitween/presenter/model/json/level.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user/battle.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/contents/achievement/level.dart';
import 'package:fitween/presenter/page/contents/challenge/challenge_detail.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/presenter/page/contents/contents.dart';
import 'package:fitween/presenter/page/contents/workout/battle/record.dart';
import 'package:fitween/presenter/page/contents/workout/battle/result.dart';
import 'package:fitween/presenter/page/contents/workout/friend.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/icon.dart';
import 'package:fitween/view/widget/widget/list_tile.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:fitween/view/widget/widget/toggle_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChallengeCardView extends StatefulWidget {
  const ChallengeCardView({Key? key}) : super(key: key);

  @override
  State<ChallengeCardView> createState() => _ChallengeCardViewState();
}

class _ChallengeCardViewState extends State<ChallengeCardView> {

  @override
  Widget build(BuildContext context) {
    final refreshCont = RefreshController();
    final userPartyP = Get.find<UserPartyP>();
    FUserParty user = userPartyP.loggedUser;

    return SmartRefresher(
      controller: refreshCont,
      onRefresh: () async {
        try {
          await ContentsP.init();
          setState(() {});
          refreshCont.refreshCompleted();
        } catch (e) {
          refreshCont.refreshFailed();
        }
      },
      onLoading: () async {
        await Future.delayed(const Duration(milliseconds: 100));
        refreshCont.loadComplete();
      },
      header: const MaterialClassicHeader(
        color: FTheme.black,
        backgroundColor: FTheme.surface,
      ),
      child: GetBuilder<LoadingP>(
        builder: (loadingP) {
          List<Party> parties = user.parties.values.toList();
          List<Challenge> newChallenges = ChallengeJsonP
              .orderedChallenges.where((party) => !party.locked)
              .where((challenge) => !parties
              .map((party) => party.challengeId)
              .contains(challenge.id)).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FToggleListWidget(
                  text: Lang.tr('party.joined'),
                  list: parties.map((party) => loadingP.loading ? FCard(
                    constraints: BoxConstraints(minHeight: 140.0.h),
                    child: const SizedBox(),
                  ) : ChallengeCard(
                    challenge: ChallengeJsonP.getChallenge(party.challengeId!)
                        ?? ChallengeJsonP.orderedChallenges.first,
                    isHero: false,
                    onPressed: () => PartyP.toParty(party),
                    party: party,
                  )).toList(),
                  emptyText: Lang.tr('party.no'),
                ),
                SizedBox(height: 20.0.h),
                FToggleListWidget(
                  text: Lang.tr('challenge.new'),
                  list: newChallenges.map((challenge) => loadingP.loading ? FCard(
                    constraints: BoxConstraints(minHeight: 130.0.h),
                    child: const SizedBox(),
                  ) : ChallengeCard(
                    challenge: challenge,
                    onPressed: () => ChallengeDetailP.toChallengeDetail(
                      challenge,
                    ),
                  )).toList(),
                  emptyText: Lang.tr('challenge.no'),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}



class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    Key? key,
    required this.challenge,
    this.party,
    this.onPressed,
    this.isHero = true,
  }) : super(key: key);

  final Challenge challenge;
  final VoidCallback? onPressed;
  final Party? party;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(12.0.r),
      ),
      child: Stack(
        children: [
          SizedBox(
            child: Image.asset(
              challenge.imageUrls['default'],
              width: 100.0.w,
              height: 140.0.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: FTheme.black.withOpacity(.2),
            ),
          ),
          Positioned(
            left: 5.0, top: 10.0,
            child: FTag(
              challenge.type!.locale.capitalize!,
              backgroundColor: challenge.type!.color,
              bold: true,
            ),
          ),
        ],
      ),
    );

    return FCard(
      onPressed: onPressed,
      backgroundColor: FTheme.white,
      padding: EdgeInsets.zero,
      height: 140.0.h,
      child: Row(
        children: [
          isHero ? Hero(
            tag: challenge.id!,
            child: imageWidget,
          ) : imageWidget,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14.0.r, vertical: 5.0.r,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FText(
                    challenge.title ?? '',
                    bold: true,
                    maxLines: 2,
                    style: textTheme(context).titleSmall,
                  ),
                  SizedBox(height: 4.0.h),
                  FText(
                    challenge.sub,
                    style: textTheme(context).bodySmall,
                    color: FTheme.lightGrey,
                    maxLines: 2,
                  ),
                  SizedBox(height: 10.0.h),
                  if(party == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FTag(challenge.period!.d),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: FTheme.lightGrey,
                            size: 20.0.r,
                          ),
                          FText(
                            '${challenge.levels['easy']['maxMember']}',
                            color: FTheme.lightGrey,
                            style: textTheme(context).bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ) else Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FTag('D${withSign(party!.overDays)}'),
                          Builder(
                            builder: (context) {
                              String text = party!.satisfy ? Lang.tr('party.done')
                                  : (party!.over ? Lang.tr('party.fail') : Lang.tr('party.undone'));
                              Color color = party!.satisfy ? challenge.type!.color
                                  : (party!.over ? FTheme.error : FTheme.lightGrey);
                              return FTag(text.capitalize!, backgroundColor: color);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: FTheme.lightGrey,
                            size: 20.0.r,
                          ),
                          FText(
                            '${party!.memberUids.length}/${party!.maxMember}',
                            color: FTheme.lightGrey,
                            style: textTheme(context).bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementCardView extends StatelessWidget {
  const AchievementCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final refreshCont = RefreshController();

    bool isPortrait = orientation == Orientation.portrait;

    FUserRecord loggedUser = Get.find<UserRecordP>().loggedUser;
    FUserInfo userInfo = Get.find<UserInfoP>().loggedUser;

    double ratio = (30 / 43);
    // if (!isPortrait) ratio = 1 / ratio;

    return SmartRefresher(
      controller: refreshCont,
      onRefresh: () async {
        try {
          await ContentsP.init();
          refreshCont.refreshCompleted();
        } catch (e) {
          refreshCont.refreshFailed();
        }
      },
      onLoading: () async {
        await Future.delayed(const Duration(milliseconds: 100));
        refreshCont.loadComplete();
      },
      header: const MaterialClassicHeader(
        color: FTheme.black,
        backgroundColor: FTheme.surface,
      ),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isPortrait ? 1 : 2,
          childAspectRatio: ratio,
          mainAxisSpacing: 20.0.r,
          crossAxisSpacing: 20.0.r,
        ),
        children: ActivityType.activeValues.map((type) {
          double amount = loggedUser.getAmounts(type);
          ExerciseUnit? unit = {
            ActivityType.distance: ExerciseUnit.step,
            ActivityType.weight: ExerciseUnit.count,
          }[type];

          Record record = Record.init(type, amount, unit);

          Map<String, dynamic> tier = LevelJsonP.getTier(type, record);
          List<Level> levels = LevelJsonP.getUnlockedLevels(type, record);
          Level? next = tier['next'];

          // if (next == null) return Container();

          Record nextValue = Record.init(
            type,
            next!.amount!.toDouble(),
            ExerciseUnit.kilometer,
          );

          nextValue.convert(unit);

          return FCard(
            child: AspectRatio(
              aspectRatio: ratio,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  LevelButton(
                    level: levels.length,
                    onPressed: () => AchievementLevelP.toAchievementLevel(type),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProgressTextWidget(tier: tier, type: type, userInfo: userInfo),
                      ProgressImageWidget(tier: tier, type: type),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      // child: SingleChildScrollView(
      //   child: Column(
      //     children: ActivityType.activeValues.map((type) {
      //       double amount = loggedUser.getAmounts(type);
      //       ExerciseUnit? unit = {
      //         ActivityType.distance: ExerciseUnit.step,
      //         ActivityType.weight: ExerciseUnit.count,
      //       }[type];
      //
      //       Record record = Record.init(type, amount, unit);
      //
      //       Map<String, dynamic> tier = LevelJsonP.getTier(type, record);
      //       List<Level> levels = LevelJsonP.getUnlockedLevels(type, record);
      //       Level? next = tier['next'];
      //
      //       if (next == null) return Container();
      //
      //       Record nextValue = Record.init(
      //         type,
      //         next.amount!.toDouble(),
      //         ExerciseUnit.kilometer,
      //       );
      //
      //       nextValue.convert(unit);
      //
      //       return Padding(
      //         padding: EdgeInsets.symmetric(vertical: 10.0.h),
      //         child: FCard(
      //           height: 470.0.h,
      //           child: Expanded(
      //             child: Stack(
      //               alignment: Alignment.topRight,
      //               children: [
      //                 Column(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     ProgressTextWidget(tier: tier, type: type, userInfo: userInfo),
      //                     ProgressImageWidget(tier: tier, type: type),
      //                   ],
      //                 ),
      //                 LevelButton(
      //                   level: levels.length,
      //                   onPressed: () => AchievementLevelP.toAchievementLevel(type),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       );
      //     }).toList(),
      //   ),
      // ),
    );
  }
}

class ProgressTextWidget extends StatefulWidget {
  const ProgressTextWidget({
    Key? key,
    required this.tier,
    required this.type,
    required this.userInfo,
  }) : super(key: key);

  final Map<String, dynamic> tier;
  final ActivityType type;
  final FUserInfo userInfo;

  @override
  State<ProgressTextWidget> createState() => _ProgressTextWidgetState();
}

class _ProgressTextWidgetState extends State<ProgressTextWidget> {
  bool isText = true;
  late Timer timer;
  late String text;
  late String amountString;

  @override
  void initState() {
    final userRecordP = Get.find<UserRecordP>();
    double amount = userRecordP.loggedUser.getAmounts(widget.type);

    if (widget.type == ActivityType.distance) amount = amount ~/ 100 * 100;

    text = widget.tier['current']?.title ?? '';

    String unit = typeUnit(amount, widget.type, onlyUnit: true);
    amountString = '${toLocalString(amount)} @{$unit}';

    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() => isText = !isText);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    bool isPortrait = orientation == Orientation.portrait;

    bool isLong = true;

    if (text.length > 10) {
      // twoLineText = '${text.substring(0, text.length ~/ 3 * 2)}'
      //     '\n${text.substring(text.length ~/ 3 * 2, text.length)}';
      if (size.width < 600 / (isPortrait ? 1 : 2)) isLong = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FTextsT(
          Lang.tr(
            'ctnt.lvl.${widget.type.name}.pre.${isText ? 'obj' : 'val'}',
            args: [widget.userInfo.nickname!],
          ),
          textColor: FTheme.darkGrey,
          style: textTheme(context).bodyMedium,
          highlightStyles: [
            textTheme(context).titleSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: 5.0.h),
        GestureDetector(
          onTap: () {
            setState(() => isText = !isText); timer.cancel();
            timer = Timer.periodic(const Duration(seconds: 5), (_) {
              setState(() => isText = !isText);
            });
          },
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: isText ? 1.0 : .0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: 48.0.h,
                  padding: EdgeInsets.all(5.0.r),
                  decoration: BoxDecoration(
                    color: widget.type.color,
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: Builder(
                    builder: (context) {
                      TextStyle? style = isLong
                          ? textTheme(context).displaySmall
                          : textTheme(context).titleLarge;
                      return FText(text,
                        style: style,
                        color: FTheme.white,
                        bold: true,
                      );
                    }
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: isText ? .0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: 48.0.r,
                  padding: EdgeInsets.all(5.0.r),
                  decoration: BoxDecoration(
                    color: widget.type.color,
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: FTextsT(
                    amountString,
                    textColor: FTheme.white,
                    style: textTheme(context).displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    highlightStyles: [
                      textTheme(context).titleSmall!.copyWith(
                        color: FTheme.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0.h),
        FText(
          Lang.tr('ctnt.lvl.${widget.type.name}.post.${isText ? 'obj' : 'val'}'),
          style: textTheme(context).bodyMedium,
        ),
        SizedBox(height: 8.0.h),
      ],
    );
  }
}


class ProgressImageWidget extends StatefulWidget {
  const ProgressImageWidget({
    Key? key,
    required this.tier,
    required this.type,
  }) : super(key: key);

  final Map<String, dynamic> tier;
  final ActivityType type;

  @override
  State<ProgressImageWidget> createState() => _ProgressImageWidgetState();
}

class _ProgressImageWidgetState extends State<ProgressImageWidget> {
  late bool visible;
  late bool downed;
  late double position;
  late Timer timer;
  late Duration duration;

  @override
  void initState() {
    visible = false;
    downed = true;
    position = .4;
    duration = const Duration(seconds: 1);
    Future.delayed(Duration.zero, () => setState(() {
      visible = true; position = .45;
      duration = const Duration(milliseconds: 700);
    }));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        duration = const Duration(seconds: 1);
        position = (downed ? .5 : .45);
        downed = !downed;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  ExerciseUnit? get beforeUnit => {
    ActivityType.distance: ExerciseUnit.kilometer,
    ActivityType.weight: ExerciseUnit.weight,
  }[widget.type];

  ExerciseUnit? get afterUnit => {
    ActivityType.distance: ExerciseUnit.step,
    ActivityType.weight: ExerciseUnit.count,
  }[widget.type];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    final userRecordP = Get.find<UserRecordP>();
    double amount = userRecordP.loggedUser.getAmounts(widget.type);

    String id = widget.tier['current'].id;
    double current = widget.tier['current'].amount;
    double next = widget.tier['next'].amount;
    double percent = widget.tier['percent'];

    Record currentRecord = Record.init(widget.type, current, beforeUnit);
    Record nextRecord = Record.init(widget.type, next, beforeUnit);

    currentRecord.convert(afterUnit);
    nextRecord.convert(afterUnit);

    int displayAmount = (amount - currentRecord.amount).round();
    int displayTotal = (nextRecord.amount - currentRecord.amount).round();

    if (widget.type == ActivityType.distance) {
      displayAmount = displayAmount > 1000 ? displayAmount ~/ 100 * 100 : displayAmount;
      displayTotal = displayTotal > 1000 ? displayTotal ~/ 100 * 100 : displayTotal;
    }

    String amountString = toLocalString(displayAmount);
    String totalString = toLocalString(displayTotal);

    bool isPortrait = orientation == Orientation.portrait;

    const unionRatio = 588 / 561;
    double unionWidth = size.width * (isPortrait ? .7 : .35);
    double unionHeight = unionWidth / unionRatio;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/image/page/contents/union.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        AnimatedPositioned(
          bottom: position * unionHeight,
          duration: duration,
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: visible ? 1.0 : .0,
            child: SizedBox(
              width: 80.0.w / (isPortrait ? 1 : 2),
              child: widget.tier['current'] != null ? Image.asset(
                'assets/image/level/${widget.type.name}/$id.png',
                width: 80.0.w / (isPortrait ? 1 : 2),
              ) : Container(),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0.w / (isPortrait ? 1 : 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText(
                Lang.tr('ctnt.lvl.next'),
                style: textTheme(context).bodySmall,
                color: FTheme.lightGrey,
              ),
              SizedBox(height: 5.0.h),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                progressColor: widget.type.color,
                backgroundColor: const Color(0xFFE9E9E9),
                percent: max(percent, .02),
                lineHeight: 40.0.h,
                barRadius: Radius.circular(6.28.r),
                animation: true,
                animationDuration: 1000,
                curve: Curves.easeInOut,
              ),
              FText(
                '$amountString/$totalString ${typeUnit(amount, widget.type, onlyUnit: true)}',
                style: textTheme(context).bodyMedium,
                color: widget.type.color,
              ),
              SizedBox(height: 10.0.h),
            ],
          ),
        ),
      ],
    );
  }
}

class LevelButton extends StatefulWidget {
  const LevelButton({
    Key? key,
    required this.level,
    required this.onPressed,
  }) : super(key: key);

  final int level;
  final VoidCallback? onPressed;

  @override
  State<LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<LevelButton> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;

  double scale = 1.0;
  Duration duration = const Duration(milliseconds: 100);

  @override
  void initState() {
    onTapDown = widget.onPressed == null ? null : (_) {
      setState(() => scale = .9);
    };
    onTapUp = widget.onPressed == null ? null : (_) async {
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() => scale = 1.0);
      });
      widget.onPressed!();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(20.0);

    return AnimatedScale(
      scale: scale,
      duration: duration,
      child: GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: () => setState(() => scale = 1.0),
        child: Material(
          color: FTheme.darkGrey,
          borderRadius: radius,
          child: Container(
            padding: EdgeInsets.fromLTRB(8.0.r, 4.0.r, 4.0.r, 4.0.r),
            decoration: BoxDecoration(borderRadius: radius),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FText('Lv ${widget.level}', style: textTheme(context).bodySmall, color: FTheme.white),
                Icon(Icons.chevron_right, size: 14.0.r, color: FTheme.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class BattleCardView extends StatelessWidget {
  const BattleCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refreshCont = RefreshController();
    final userBattleP = Get.find<UserBattleP>();

    return SmartRefresher(
      controller: refreshCont,
      onRefresh: () async {
        try {
          await ContentsP.init();
          refreshCont.refreshCompleted();
        } catch (e) {
          refreshCont.refreshFailed();
        }
      },
      onLoading: () async {
        await Future.delayed(const Duration(milliseconds: 100));
        refreshCont.loadComplete();
      },
      header: const MaterialClassicHeader(
        color: FTheme.black,
        backgroundColor: FTheme.surface,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FCard(
              constraints: BoxConstraints(minHeight: 80.0.h),
              child: FButton(
                text: Lang.tr('btn.rcnt-res'),
                stretch: true,
                backgroundColor: FTheme.colorD,
                onPressed: BattleRecordP.toBattleRecord,
              ),
            ),
            SizedBox(height: 20.0.h),
            Column(
              children: userBattleP.loggedUser.visibleBattles.values.map((battle) {
                return Column(
                  children: [
                    FCard(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FText(
                            (battle.finished ? Lang.tr('complete') : Lang.tr('in-progress')).capitalize!,
                            style: textTheme(context).titleLarge,
                            bold: true,
                          ),
                          RemainingTimeWidget(battle: battle),
                        ],
                      ),
                      constraints: const BoxConstraints(minHeight: 230.0),
                      onPressed: battle.finished
                          ? null : () => ContentsP.unfinishedBattleCardPressed(battle.id!),
                      child: Column(
                        children: [
                          BattleCardContentWidget(battle: battle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                );
              }).toList(),
            ),

            FCard(
              title: FText('${Lang.tr('btl.squat').capitalize}!',
                style: textTheme(context).titleLarge,
                bold: true,
              ),
              height: 420.0.h,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/image/page/contents/fight.png',
                      height: 180.0.h,
                    ),
                    FTextsT(
                      Lang.tr(
                        'btl.card-cmt',
                        args: [Lang.tr('btl.squat')],
                      ),
                      style: textTheme(context).titleSmall,
                      highlightStyle: textTheme(context).titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ActivityType.weight.color,
                      ),
                    ),
                    FButton(
                      stretch: true,
                      text: Lang.tr('btn.goto-btl'),
                      onPressed: () {
                        ExerciseHandler.workout = Workout.squat;
                        WorkoutFriendP.toWorkoutFriend();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0.h),
            FCard(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FText('${Lang.tr('btl.sldr-press').capitalize}!',
                    style: textTheme(context).titleLarge,
                    bold: true,
                  ),
                  const FTag('Beta'),
                ],
              ),
              height: 420.0.h,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/image/page/contents/fight.png',
                      height: 180.0.h,
                    ),
                    FTextsT(
                      Lang.tr(
                        'btl.card-cmt',
                        args: [Lang.tr('btl.sldr-press')],
                      ),
                      style: textTheme(context).titleSmall,
                      highlightStyle: textTheme(context).titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ActivityType.weight.color,
                      ),
                    ),
                    FButton(
                      stretch: true,
                      text: Lang.tr('btn.goto-btl'),
                      onPressed: () {
                        ExerciseHandler.workout = Workout.shoulderPress;
                        WorkoutFriendP.toWorkoutFriend();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BattleCardContentWidget extends StatelessWidget {
  const BattleCardContentWidget({
    Key? key,
    required this.battle,
  }) : super(key: key);

  final Battle battle;

  @override
  Widget build(BuildContext context) {
    final userCollectionP = Get.find<UserCollectionP>();
    final userInfoP = Get.find<UserInfoP>();
    final userBattleP = Get.find<UserBattleP>();

    String myUid = userBattleP.loggedUser.uid!;
    String rivalUid = battle.data.keys.firstWhere((uid) => uid != myUid);

    FUserInfo myInfo = userInfoP.loggedUser;
    FUserCollection myCollection = userCollectionP.loggedUser;
    FUserInfo rivalInfo = battle.memberInfos[rivalUid]!;
    FUserCollection rivalCollection = battle.memberCollections[rivalUid]!;

    return battle.finished ? Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                FBadgeWidget(
                  size: 80.0,
                  badge: BadgeJsonP.getBadge(myCollection.badgeId),
                ),
                const SizedBox(height: 8.0),
                const MeTag(),
              ],
            ),
            const FIcon(FIcons.swords, selected: true),
            Column(
              children: [
                FBadgeWidget(
                  size: 80.0,
                  badge: BadgeJsonP.getBadge(rivalCollection.badgeId),
                  backgroundColor: rivalCollection.badgeColor,
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: 70.0,
                  alignment: Alignment.center,
                  child: FText(
                    rivalInfo.nickname!,
                    style: textTheme(context).bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        FButton(
          text: Lang.tr('btn.chk-res'),
          stretch: true,
          backgroundColor: ActivityType.weight.color,
          onPressed: () {
            final userP = Get.find<UserBattleP>();
            BattleResultP.toBattleResult(battle.id!, offAll: false);
            userP.hideBattle(battle.id!);
          },
          motion: true,
        ),
      ],
    ) : Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            FBadgeWidget(
              size: 80.0,
              badge: BadgeJsonP.getBadge(myCollection.badgeId),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: 70.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 35.0,
                    child: FText(
                      myInfo.nickname!,
                      style: textTheme(context).bodyMedium,
                    ),
                  ),
                  const MeTag(),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            FText(typeUnit(battle.getMaxCount(myUid), ActivityType.weight),
              color: FTheme.darkGrey,
              bold: true,
            ),
            const SizedBox(height: 5.0),
            FText('* ${Lang.tr('btl.rmn-cnt')}: ${
              typeUnit(battle.getRemainChance(myUid), ActivityType.weight)
            }',
              color: FTheme.lightGrey,
              style: textTheme(context).labelMedium,
            ),
          ],
        ),
        const FIcon(FIcons.swords, selected: true),
        Column(
          children: [
            FBadgeWidget(
              size: 80.0,
              badge: BadgeJsonP.getBadge(rivalCollection.badgeId),
              backgroundColor: rivalCollection.badgeColor,
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 70.0,
              alignment: Alignment.center,
              child: FText(
                rivalInfo.nickname!,
                style: textTheme(context).bodyMedium,
              ),
            ),
            const SizedBox(height: 8.0),
            FText(
              '${battle.getMaxCount(rivalUid) == 0 ? 0 : '??'}회',
              color: FTheme.grey,
            ),
            const SizedBox(height: 5.0),
            FText('* 남은 기회: ${battle.getRemainChance(rivalUid)}회',
              color: FTheme.lightGrey,
              style: textTheme(context).labelMedium,
            ),
          ],
        ),
      ],
    );
  }
}


class RemainingTimeWidget extends StatefulWidget {
  const RemainingTimeWidget({
    Key? key,
    required this.battle,
  }) : super(key: key);

  final Battle battle;

  @override
  State<RemainingTimeWidget> createState() => _RemainingTimeWidgetState();
}

class _RemainingTimeWidgetState extends State<RemainingTimeWidget> {
  int timerSeconds = 0;
  late Timer timer;

  @override
  void initState() {
    timerSeconds = widget.battle.genDate!
        .add(const Duration(days: 1)).difference(now).inSeconds;
    setState(() {});

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => timerSeconds = max(timerSeconds - 1, 0));
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  int get hour => timerSeconds ~/ 3600;
  int get minute => (timerSeconds - hour * 3600) ~/ 60;
  int get second => timerSeconds % 60;

  String get timeString {
    String text = '';
    if (hour > 0) text += ' ${Lang.plural('unit.w-num.time.hour', hour)}';
    if (minute > 0) text += ' ${Lang.plural('unit.w-num.time.minute', minute)}';
    if (second > 0) text += ' ${Lang.plural('unit.w-num.time.second', second)}';
    return text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return FText(
      (widget.battle.expired
          ? Lang.tr('expired')
          : Lang.tr('time-left', args: [timeString])
      ).capitalize!,
      style: textTheme(context).labelMedium,
      color: FTheme.lightGrey,
    );
  }
}