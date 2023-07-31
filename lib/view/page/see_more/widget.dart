import 'dart:math';

import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/see_more/collection/collection.dart';
import 'package:fitween/presenter/page/see_more/goal_edit/goal_edit.dart';
import 'package:fitween/presenter/page/see_more/info_edit/info_edit.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BadgeManagementCard extends StatelessWidget {
  const BadgeManagementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserCollectionP>(
      builder: (userCollectionP) {
        FBadge badge = BadgeJsonP.getBadge(userCollectionP.loggedUser.badgeId!)!;
        List<Collection> collections = userCollectionP.loggedUser.orderedCollections
            .where((collection) => collection.badgeId != userCollectionP.loggedUser.badgeId)
            .toList();
        List<Collection> subCollections = collections
            .sublist(0, min(collections.length, 2));


        return FCard(
          title: FText(
            Lang.tr('badge.setting'),
            style: textTheme(context).bodyMedium,
            color: FTheme.lightGrey,
            bold: true,
          ),
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: CollectionP.toCollection,
          constraints: BoxConstraints(minHeight: 220.0.h),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 100.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FBadgeWidget(badge: badge, size: 78.0),
                            const SizedBox(height: 5.0),
                            FText(
                              badge.title!,
                              style: textTheme(context).bodyMedium,
                            ),
                            const SizedBox(height: 5.0),
                            FTag(Lang.tr('main').capitalize!,
                              left: false,
                              backgroundColor: FTheme.darkGrey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: FTheme.stroke,
                      thickness: .5,
                      width: 40.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FText(
                                Lang.tr('badge.recent'),
                                style: textTheme(context).bodyMedium,
                                color: FTheme.lightGrey,
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: subCollections.map((collection) => SizedBox(
                                  width: 70.0.w,
                                  child: Column(
                                    children: [
                                      FBadgeWidget(
                                        size: 50.0,
                                        badge: collection.badge,
                                      ),
                                      const SizedBox(height: 5.0),
                                      FText(
                                        collection.badge!.title!,
                                        style: textTheme(context).bodySmall,
                                      ),
                                    ],
                                  ),
                                )).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GoalEditCard extends StatelessWidget {
  const GoalEditCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfoP = Get.find<UserInfoP>();
    final userRecordP = Get.find<UserRecordP>();

    return FCard(
      title: FText(
        Lang.tr('goal-edit.'),
        style: textTheme(context).bodyMedium,
        color: FTheme.lightGrey,
        bold: true,
      ),
      icon: const Icon(Icons.edit),
      onPressed: GoalEditP.toGoalEdit,
      constraints: BoxConstraints(minHeight: 150.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 70.0.h,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ActivityType.activeValues.length,
              itemBuilder: (context, index) {
                ActivityType type = ActivityType.activeValues[index];
                bool registeredToday = isSameDate(userInfoP.loggedUser.regDate!, today);
                Record newGoal = userRecordP.loggedUser.getGoal(type, tomorrow)!;
                Record goal = userRecordP.loggedUser.getGoal(type, today)!;

                return SizedBox(
                  width: 75.0.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FText(type.locale.capitalize!, style: textTheme(context).bodyMedium),
                      FText(
                        toLocalString(newGoal.amount),
                        color: type.color,
                        style: textTheme(context).titleMedium,
                      ),
                      if (!registeredToday && newGoal.amount != goal.amount)
                      FText(
                        '* ${Lang.tr('goal-edit.be-upd')}',
                        style: textTheme(context).bodySmall,
                        color: FTheme.lightGrey,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => VerticalDivider(
                color: FTheme.stroke,
                thickness: .5,
                width: 20.0.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class InfoEditCard extends StatelessWidget {
  const InfoEditCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserInfoP>();

    return FCard(
      title: FText(
        Lang.tr('info.edit.'),
        style: textTheme(context).bodyMedium,
        color: FTheme.lightGrey,
        bold: true,
      ),
      icon: const Icon(Icons.edit),
      onPressed: InfoEditP.toInfoEdit,
      constraints: BoxConstraints(minHeight: 270.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText(
                Lang.tr('nickname').capitalize!,
                style: textTheme(context).bodyMedium,
                color: FTheme.lightGrey,
              ),
              SizedBox(height: 5.0.h),
              FText(userP.loggedUser.nickname!),
            ],
          ),
          SizedBox(height: 10.0.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText(
                Lang.tr('height').capitalize!,
                style: textTheme(context).bodyMedium,
                color: FTheme.lightGrey,
              ),
              SizedBox(height: 5.0.h),
              Stack(
                children: [
                  FText('${userP.loggedUser.height!}cm'),
                  if (!(userP.loggedUser.heightVisibility ?? true))
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: FTheme.grey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText(
                Lang.tr('weight').capitalize!,
                style: textTheme(context).bodyMedium,
                color: FTheme.lightGrey,
              ),
              SizedBox(height: 5.0.h),
              Stack(
                children: [
                  FText('${userP.loggedUser.weight!}kg'),
                  if (!(userP.loggedUser.weightVisibility ?? true))
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: FTheme.grey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}