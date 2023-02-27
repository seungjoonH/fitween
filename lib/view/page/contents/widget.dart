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
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/contents/challenge/challenge_detail.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/presenter/page/contents/contents.dart';
import 'package:fitween/presenter/page/contents/time_attack/friend.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/card.dart';
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
    List<Party> parties = user.parties.values.toList();

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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        );
                      },
                      separatorBuilder: (_, index) => SizedBox(height: 30.0.h),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
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
                      itemCount: loadingP.loading ? 2 : ChallengeJsonP.orderedChallenges.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            ChallengeDetailP.toChallengeDetail(
                              ChallengeJsonP.orderedChallenges[index],
                            );
                          },
                          child: loadingP.loading ? FCard(
                            constraints: const BoxConstraints(minHeight: 100.0),
                            child: const SizedBox(),
                          ) : ChallengeCard(
                            challenge: ChallengeJsonP.orderedChallenges[index],
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
    this.onPressed,
    this.isHero = true,
  }) : super(key: key);

  final Challenge challenge;
  final VoidCallback? onPressed;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ClipRRect(
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(12.0),
      ),
      child: Image.asset(
        challenge.imageUrls['default'],
        width: 100.0,
        height: 100.0,
        fit: BoxFit.fitWidth,
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
            tag: '${challenge.id}',
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
    FUserRecord loggedUser = Get.find<UserRecordP>().loggedUser;
    FUserInfo userInfo = Get.find<UserInfoP>().loggedUser;

    return SingleChildScrollView(
      child: Column(
        children: ActivityType.activeValues.map((type) {
          double amount = loggedUser.getAmounts(type);
          ExerciseUnit? unit = {
            ActivityType.distance: ExerciseUnit.step,
            ActivityType.weight: ExerciseUnit.count,
          }[type];

          Record record = Record.init(type, amount, unit);

          Map<String, dynamic> tier = LevelJsonP.getTier(type, record);
          Level next = tier['next'] ?? Level.fromJson({'amount': 0});

          Record nextValue = Record.init(
            type,
            next.amount!.toDouble(),
            ExerciseUnit.kilometer,
          );

          nextValue.convert(unit);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: FCard(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FText(
                        '${userInfo.nickname}님은 지금까지',
                        style: textTheme.bodyLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: type.color,
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                        child: FText(
                          tier['current']?.title ?? '',
                          maxLines: 2,
                          style: textTheme.displayMedium,
                          color: FTheme.white,
                          bold: true,
                        ),
                      ),
                      FText(
                        '만큼 ${type.did}!',
                        style: textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8.0),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/image/page/contents/union.png',
                            width: 300.0,
                            fit: BoxFit.fitWidth,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: 100.0.w,
                                child: tier['current'] != null ? Image.asset(
                                  'assets/image/level/${type.name}/${tier['current'].id}.png',
                                  width: 40.0.w,
                                ) : Container(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FText(
                                      '현재 진행도',
                                      style: textTheme.bodyMedium,
                                      color: FTheme.black,
                                    ),
                                    const SizedBox(height: 5.0),
                                    LinearPercentIndicator(
                                      padding: EdgeInsets.zero,
                                      progressColor: type.color,
                                      backgroundColor: FTheme.lightGrey,
                                      // Colors.transparent,
                                      percent: tier['percent'] ?? .0,
                                      lineHeight: 48.0,
                                      barRadius: Radius.circular(10.0.r),
                                      animation: true,
                                      animationDuration: 1000,
                                      curve: Curves.easeInOut,
                                    ),
                                    FText(
                                      '${tier['percent'].toInt()}%',
                                      style: textTheme.bodyMedium,
                                      color: type.color,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (!type.active)
                  Positioned.fill(
                    child: Stack(
                      children: [
                        Container(
                          color: FTheme.surface,
                          alignment: Alignment.center,
                          child: Icon(Icons.lock, size: 30.0.r),
                        ),
                        Container(
                          color: FTheme.black.withOpacity(.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TimeAttackCardView extends StatelessWidget {
  const TimeAttackCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FCard(
          title: '타임어택!',
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
                  '친구와 제한 시간 내에\n누가 더 스쿼트를 많이 하는지\n대결해요!',
                  maxLines: 3,
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
    );
  }
}
