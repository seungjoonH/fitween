import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/quest.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';

class MonthlyQuestView extends StatelessWidget {
  const MonthlyQuestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0.r),
            child: PCard(
              color: FTheme.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FText(
                    '${today.month}월의 목표',
                    style: textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BadgeWidget(
                          badge: BadgePresenter.getThisMonthQuestBadge(ActivityType.distance),
                          size: 60.0,
                        ),
                        BadgeWidget(
                          badge: BadgePresenter.getThisMonthQuestBadge(ActivityType.calorie),
                        ),
                        BadgeWidget(
                          badge: BadgePresenter.getThisMonthQuestBadge(ActivityType.height),
                          size: 60.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 2.0, color: FTheme.black, height: 5.0),
          Container(
            height: 500.0.h,
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FText('이달의 목표',
                      style: textTheme.headlineSmall,
                    ),
                    FText(
                      '월간 목표 달성으로 자신의 한계에 도전해 보세요.\n이번 ${today.month}월의 목표를 달성하시면 특별 뱃지를 획득 하실 수 있습니다.',
                      style: textTheme.bodySmall,
                      color: FTheme.outline,
                      maxLines: 3,
                    ),
                  ],
                ),
                SizedBox(height: 40.0.h),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ActivityType.activeValues.sublist(0, 3).map((type) {
                      FBadge? badge;
                      () async {
                        badge = BadgePresenter.getBadge('1040${type.index}${
                          (today.month - 1).toString().padLeft(2, '0')}'
                        );
                      }();
                      return QuestBadgePercentView(badge: badge!, type: type);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}

class QuestBadgePercentView extends StatelessWidget {
  const QuestBadgePercentView({
    Key? key,
    required this.badge,
    required this.type,
  }) : super(key: key);

  final FBadge badge;
  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserP>();

    FUser user = Get.find<UserP>().loggedUser;
    double record = user.getThisMonthAmounts(type);
    int goal = QuestPresenter.quests[type] ?? 1;
    if (type == ActivityType.weight) goal ~/= userWeight + 1;
    double percent = min(record / goal, 1);

    bool completed = percent == 1;
    bool received = user.collections.map((col) => col.badge!.id).contains(badge.id);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            BadgeWidget(
              badge: badge, size: 80.0.r,
              completed: completed,
              received: received,
              onPressed: received
                  ? null : completed
                  ? () => userP.awardBadge(badge)
                  : () => GlobalPresenter.showBadgeDialog(badge),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FTexts(['${toLocalString(goal)}${type.unit}', type.doIt],
                  colors: [type.color, FTheme.black],
                  alignment: MainAxisAlignment.start,
                ),
                const SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: FTheme.black, width: 1.5),
                  ),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    progressColor: type.color,
                    lineHeight: 30.0.h,
                    backgroundColor: FTheme.bar,
                    center: FText(
                      '${toLocalString(record)} / ${toLocalString(goal)} ${type.unit}',
                      style: textTheme.labelSmall,
                    ),
                    percent: percent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
