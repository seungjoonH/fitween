import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/battle.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/contents/workout/battle/result.dart';
import 'package:fitween/presenter/page/contents/workout/solo/result.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/effect/effect.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/icon.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BattleResultView extends StatelessWidget {
  const BattleResultView({
    Key? key,
    required this.result,
  }) : super(key: key);

  final bool result;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<BattleResultP>(
        builder: (battleResultP) {
          return Column(
            children: [
              if (result) const BattleResultCard()
              else Column(
                children: const [
                  WorkoutFinishCard(),
                  MyAchievementCard(),
                ],
              ) ,
            ],
          );
        }
      ),
    );
  }
}

class WorkoutFinishCard extends StatelessWidget {
  const WorkoutFinishCard({Key? key}) : super(key: key);

  static const String asset = 'assets/image/page/contents/workout/result_big.png';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
      child: GetBuilder<BattleResultP>(
        builder: (battleResultP) {
          const constraints = BoxConstraints(minHeight: 350.0);
          final userP = Get.find<UserInfoP>();
          Battle? battle = battleResultP.battle;

          if (battle == null) {
            return FCard(
              constraints: constraints,
              child: Container(),
            );
          }

          return FCard(
            constraints: constraints,
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    EternalRotation(
                      rps: .3,
                      child: Image.asset(
                        GlobalP.effectAsset,
                        width: 240.0,
                        height: 240.0,
                      ),
                    ),
                    Image.asset(asset),
                    FText(
                      '${battle.getAttempts(userP.loggedUser.uid!).last}회',
                      color: FTheme.white,
                      style: textTheme(context).displayMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                FButton(
                  stretch: true,
                  text: '타임어택 완료!',
                  backgroundColor: FTheme.colorA,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BattleResultCard extends StatelessWidget {
  const BattleResultCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfoP = Get.find<UserInfoP>();
    final userFriendP = Get.find<UserFriendP>();
    BoxConstraints constraints = const BoxConstraints(minHeight: 380.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 28.0.w,
        vertical: 28.0.h,
      ),
      child: GetBuilder<BattleResultP>(
        builder: (battleResultP) {
          if (battleResultP.battle == null) {
            return FCard(
              constraints: constraints,
              child: Container(),
            );
          }
          Battle battle = battleResultP.battle!;

          String myUid = userFriendP.loggedUser.uid!;
          String rivalUid = battle.memberInfos.keys.firstWhere((uid) => uid != myUid);
          FUserInfo rival = battle.memberInfos[rivalUid]!;

          FUserInfo? winnerInfo = battle.winnerInfo;

          late Color leftColor, rightColor;
          if (battle.won(userInfoP.loggedUser.uid!)) {
            leftColor = FTheme.colorC;
            rightColor = FTheme.colorB;
          }
          if (battle.defeated(userInfoP.loggedUser.uid!)) {
            leftColor = FTheme.colorB;
            rightColor = FTheme.colorC;
          }
          if (battle.tied) {
            leftColor = FTheme.colorD;
            rightColor = FTheme.colorD;
          }

          return FCard(
            title: FText(
              '대결 결과',
              style: textTheme(context).titleLarge,
              color: FTheme.darkGrey,
              bold: true,
            ),
            constraints: constraints,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    String text = battle.tied ? '비겼어요!'
                        : '${winnerInfo!.nickname!} 님이 승리하셨어요!';
                    return FText(text,
                      style: textTheme(context).bodyLarge,
                      color: FTheme.grey,
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              FBadgeWidget(
                                size: 96.0,
                                backgroundColor: leftColor,
                                defeated: battle.defeated(myUid),
                              ),
                              const SizedBox(height: 3.0),
                              Row(
                                children: [
                                  FText(
                                    userInfoP.loggedUser.nickname!,
                                    style: textTheme(context).bodyLarge,
                                  ),
                                  const MeTag(),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              FText(
                                '${battle.getMaxCount(myUid)}회',
                                bold: !battle.defeated(myUid),
                                color: battle.defeated(myUid)
                                    ? FTheme.lightGrey : FTheme.darkGrey,
                              ),
                            ],
                          ),
                          const FIcon(FIcons.swords, selected: true),
                          Column(
                            children: [
                              FBadgeWidget(
                                size: 96.0,
                                backgroundColor: rightColor,
                                defeated: battle.defeated(rivalUid),
                              ),
                              const SizedBox(height: 3.0),
                              FText(rival.nickname!, style: textTheme(context).bodyLarge),
                              const SizedBox(height: 5.0),
                              FText(
                                '${battle.getMaxCount(rivalUid)}회',
                                bold: !battle.defeated(rivalUid),
                                color: battle.defeated(rivalUid)
                                    ? FTheme.lightGrey : FTheme.darkGrey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Divider(
                      height: 30.0,
                      thickness: .5,
                      color: FTheme.stroke,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FText(
                          '상대와의 전적',
                          style: textTheme(context).bodyLarge,
                        ),
                        const SizedBox(height: 15.0),
                        Builder(
                          builder: (context) {
                            String myUid = userFriendP.loggedUser.uid!;
                            String rivalUid = battleResultP.battle!
                                .memberInfos.keys.firstWhere((uid) => myUid != uid);
                            int winCount = userFriendP.loggedUser.getWinCount(rivalUid);
                            int loseCount = userFriendP.loggedUser.getLoseCount(rivalUid);
                            int drawCount = userFriendP.loggedUser.getDrawCount(rivalUid);

                            return FButton(
                              backgroundColor: FTheme.colorA,
                              text: '$winCount승 : $drawCount무 : $loseCount패',
                              stretch: true,
                            );
                          },
                        ),
                      ],
                    ),
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

class MyAchievementCard extends StatelessWidget {
  const MyAchievementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
      child: GetBuilder<WorkoutSoloResultP>(
        builder: (workoutSoloResultP) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FCard(
                constraints: const BoxConstraints(minHeight: 280.0),
                title: FText('나의 기록',
                  style: textTheme(context).titleLarge,
                  color: FTheme.darkGrey,
                  bold: true,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FText(
                      '무게 기록 상승!',
                      style: textTheme(context).bodyLarge,
                      color: FTheme.grey,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AnimatedFlipCounter(
                          value: workoutSoloResultP.amount,
                          suffix: '회',
                          thousandSeparator: ',',
                          textStyle: textTheme(context).displayLarge?.copyWith(
                            color: ActivityType.weight.color,
                          ),
                        ),
                        FText(
                          '/ ${workoutSoloResultP.goal.round()}회',
                          color: FTheme.lightGrey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        LinearPercentIndicator(
                          percent: workoutSoloResultP.percent,
                          lineHeight: 50.0,
                          animateFromLastPercent: true,
                          backgroundColor: FTheme.background,
                          barRadius: const Radius.circular(12.0),
                          progressColor: Colors.amberAccent,
                          animation: true,
                          curve: Curves.easeInOut,
                          animationDuration: 1000,
                        ),
                        LinearPercentIndicator(
                          percent: workoutSoloResultP.initPercent,
                          lineHeight: 50.0,
                          animateFromLastPercent: true,
                          backgroundColor: Colors.transparent,
                          barRadius: const Radius.circular(12.0),
                          progressColor: ActivityType.weight.color,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Builder(
                            builder: (context) {
                              double a = workoutSoloResultP.initPercent;
                              double b = workoutSoloResultP.percent;
                              int leftFlex = ((a + b - .3) * 5000).round();
                              int rightFlex = ((1.85 - a - b) * 5000).round();
                              return Row(
                                children: [
                                  Expanded(flex: leftFlex, child: const SizedBox()),
                                  Container(
                                    width: 80.0,
                                    alignment: Alignment.center,
                                    child: FText(
                                      '+${workoutSoloResultP.addedWeight.amount.round()}회',
                                      color: FTheme.darkGrey,
                                      style: textTheme(context).bodyLarge,
                                    ),
                                  ),
                                  Expanded(flex: rightFlex, child: const SizedBox()),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100.0),
            ],
          );
        },
      ),
    );
  }
}
