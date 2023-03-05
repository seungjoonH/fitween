import 'dart:async';
import 'dart:math';

import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/class/json/challenge.dart';
import 'package:fitween/model/class/json/level.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/json/challenge.dart';
import 'package:fitween/presenter/model/json/level.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/contents/achievement/level.dart';
import 'package:fitween/presenter/page/contents/challenge/challenge_detail.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/presenter/page/contents/contents.dart';
import 'package:fitween/presenter/page/contents/time_attack/friend.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
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
  bool joiningChallenge = true;
  bool newChallenge = true;

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
              .orderedChallenges.where((challenge) => !parties
              .map((party) => party.challengeId)
              .contains(challenge.id)).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (parties.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => setState(() {
                        joiningChallenge = !joiningChallenge;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            FText('참여 중인 챌린지'),
                            const SizedBox(width: 10.0),
                            Icon(joiningChallenge
                                ? Icons.keyboard_arrow_down_outlined
                                : Icons.keyboard_arrow_up_outlined
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    if (joiningChallenge)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: loadingP.loading ? 2 : parties.length,
                      itemBuilder: (_, index) {
                        return loadingP.loading ? FCard(
                          constraints: const BoxConstraints(minHeight: 100.0),
                          child: const SizedBox(),
                        ) : ChallengeCard(
                          challenge: ChallengeJsonP.getChallenge(parties[index].challengeId!)
                              ?? ChallengeJsonP.orderedChallenges[0],
                          isHero: false,
                          onPressed: () => PartyP.toParty(parties[index]),
                          party: parties[index],
                        );
                      },
                      separatorBuilder: (_, index) => SizedBox(height: 30.0.h),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                if (newChallenges.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => setState(() {
                        newChallenge = !newChallenge;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            FText('새로운 챌린지'),
                            const SizedBox(width: 10.0),
                            Icon(newChallenge
                                ? Icons.keyboard_arrow_down_outlined
                                : Icons.keyboard_arrow_up_outlined
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    if (newChallenge)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: loadingP.loading ? 2 : newChallenges.length,
                      itemBuilder: (_, index) {
                        return loadingP.loading ? FCard(
                          constraints: const BoxConstraints(minHeight: 100.0),
                          child: const SizedBox(),
                        ) : ChallengeCard(
                          challenge: newChallenges[index],
                          onPressed: () => ChallengeDetailP.toChallengeDetail(
                            newChallenges[index],
                          ),
                        );
                      },
                      separatorBuilder: (_, index) => SizedBox(height: 30.0.h),
                    )
                  ],
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
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(12.0),
      ),
      child: Stack(
        children: [
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset(
              challenge.imageUrls['default'],
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            width: 100.0,
            height: 100.0,
            color: FTheme.black.withOpacity(.2),
          ),
        ],
      ),
    );

    return challenge.locked ? Container() : FCard(
      onPressed: onPressed,
      backgroundColor: FTheme.white,
      padding: const EdgeInsets.all(0.0),
      constraints: const BoxConstraints(minHeight: 100.0),
      child: Row(
        children: [
          isHero ? Hero(
            tag: challenge.id!,
            child: imageWidget,
          ) : imageWidget,
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FText(
                    challenge.title ?? '',
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4.0.h),
                  FText(
                    challenge.descriptions['sub']!,
                    style: textTheme.bodySmall,
                    color: FTheme.lightGrey,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4.0.h),
                  if(party == null)
                  Row(
                    children: [
                      FTag('${challenge.levels['easy']['maxMember']}명'),
                      FTag('D-${challenge.period}'),
                      FTag(challenge.type!.kr),
                    ],
                  ) else Row(
                    children: [
                      FTag('${party?.memberUids.length}명'),
                      FTag('D-${party?.remainDays}'),
                      FTag(challenge.type!.kr),
                      Builder(
                        builder: (context) {
                          String text = party!.satisfy ? '완료'
                              : (party!.over ? '실패' : '미완료');
                          Color color = party!.satisfy ? FTheme.colorC
                              : (party!.over ? FTheme.colorB : FTheme.lightGrey);
                          return FTag(text, backgroundColor: color);
                        },
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
    final refreshCont = RefreshController();

    FUserRecord loggedUser = Get.find<UserRecordP>().loggedUser;
    FUserInfo userInfo = Get.find<UserInfoP>().loggedUser;

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

            if (next == null) return Container();

            Record nextValue = Record.init(
              type,
              next.amount!.toDouble(),
              ExerciseUnit.kilometer,
            );

            nextValue.convert(unit);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: FCard(
                constraints: const BoxConstraints(minHeight: 480.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProgressTextWidget(tier: tier, type: type, userInfo: userInfo),
                        ProgressImageWidget(tier: tier, type: type),
                      ],
                    ),
                    LevelButton(
                      level: levels.length,
                      onPressed: () => AchievementLevelP.toAchievementLevel(type),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
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
    if (text.length > 10) {
      text = '${text.substring(0, text.length ~/ 3 * 2)}'
          '\n${text.substring(text.length ~/ 3 * 2, text.length)}';
    }
    amountString = '${toLocalString(amount)}${widget.type.unit}';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FText(widget.userInfo.nickname!,
              style: textTheme.bodyLarge,
              bold: true,
            ),
            FText(' 님은 지금까지',
              style: textTheme.bodyLarge,
            ),
          ],
        ),
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
                opacity: isText ? .0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: 55.0,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: widget.type.color,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Builder(
                    builder: (context) {
                      bool isOneLine = !text.contains('\n');
                      int maxLines = isOneLine ? 1 : 2;
                      TextStyle? style = isOneLine
                          ? textTheme.displaySmall
                          : textTheme.titleSmall;
                      return FText(text,
                        maxLines: maxLines,
                        style: style,
                        color: FTheme.white,
                        bold: true,
                      );
                    }
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: isText ? 1.0 : .0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: 55.0,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: widget.type.color,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: FText(amountString,
                    maxLines: 1,
                    style: textTheme.displaySmall,
                    color: FTheme.white,
                    bold: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        FText(
          '만큼 ${widget.type.did}!',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 8.0),
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
    position = 155.0;
    duration = const Duration(seconds: 1);
    Future.delayed(Duration.zero, () => setState(() {
      visible = true; position = 125.0;
      duration = const Duration(milliseconds: 700);
    }));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        duration = const Duration(seconds: 1);
        position = downed ? 130.0 : 125.0;
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
    ActivityType.weight: ExerciseUnit.count,
  }[widget.type];

  ExerciseUnit? get afterUnit => {
    ActivityType.distance: ExerciseUnit.step,
    ActivityType.weight: ExerciseUnit.count,
  }[widget.type];

  @override
  Widget build(BuildContext context) {
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
    // String percentString = '${(percent * 100).round()}%';

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 320.0,
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/image/page/contents/union.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        AnimatedPositioned(
          bottom: position,
          duration: duration,
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: visible ? 1.0 : .0,
            child: SizedBox(
              width: 80.0.w,
              child: widget.tier['current'] != null ? Image.asset(
                'assets/image/level/${widget.type.name}/$id.png',
                width: 40.0.w,
              ) : Container(),
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          child: Container(
            width: 300.0,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FText(
                  '다음 레벨까지',
                  style: textTheme.bodyMedium,
                  color: FTheme.black,
                ),
                const SizedBox(height: 5.0),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  progressColor: widget.type.color,
                  backgroundColor: const Color(0xFFE9E9E9),
                  percent: max(percent, .02),
                  lineHeight: 48.0,
                  barRadius: const Radius.circular(6.28),
                  animation: true,
                  animationDuration: 1000,
                  curve: Curves.easeInOut,
                ),
                FText(
                  '$amountString/$totalString ${widget.type.unit}',// $percentString',
                  style: textTheme.bodyMedium,
                  color: widget.type.color,
                ),
              ],
            ),
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
            padding: const EdgeInsets.fromLTRB(12.0, 6.0, 6.0, 6.0),
            decoration: BoxDecoration(borderRadius: radius),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FText('Level ${widget.level}', style: textTheme.bodySmall, color: FTheme.white),
                const Icon(Icons.chevron_right, size: 14.0, color: FTheme.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class TimeAttackCardView extends StatelessWidget {
  const TimeAttackCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refreshCont = RefreshController();
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
              title: FText('스쿼트!',
                style: textTheme.titleLarge,
                bold: true,
              ),
              constraints: const BoxConstraints(maxHeight: 420.0),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/image/page/contents/fight.png',
                      height: 180.0,
                    ),
                    FText(
                      '친구와 제한 시간 내에\n누가 더 스쿼트를 많이 하는지 대결해요!',
                      maxLines: 2,
                      style: textTheme.titleSmall,
                    ),
                    FButton(
                      stretch: true,
                      text: '타임어택 하러가기',
                      onPressed: TimeAttackFriendP.toTimeAttackFriend,
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
