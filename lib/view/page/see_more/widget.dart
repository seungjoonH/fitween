import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/see_more/collection/collection.dart';
import 'package:fitween/presenter/page/see_more/info_edit/info_edit.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BadgeManagementCard extends StatelessWidget {
  const BadgeManagementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCollection = Get.find<UserCollectionP>();
    FBadge badge = BadgeJsonP.getBadge(userCollection.loggedUser.badgeId!)!;

    return FCard(
      title: FText(
        '뱃지 관리',
        style: textTheme.bodyMedium,
        color: FTheme.lightGrey,
        bold: true,
      ),
      icon: const Icon(Icons.arrow_forward_ios),
      onPressed: CollectionP.toCollection,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FBadgeWidget(badge: badge, size: 96.0),
                    const SizedBox(height: 5.0),
                    FText(badge.title!, style: textTheme.bodyMedium),
                    const SizedBox(height: 5.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: FTheme.darkGrey,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: FText(
                        '대표',
                        color: FTheme.white,
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(
                  color: FTheme.stroke,
                  thickness: .5,
                  width: 40.0,
                ),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FText(
                          '최근',
                          style: textTheme.bodyMedium,
                          color: FTheme.lightGrey,
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Column(
                              children: [
                                FBadgeWidget(size: 48.0),
                                const SizedBox(height: 5.0),
                                FText(badge.title!, style: textTheme.bodyMedium),
                              ],
                            ),
                            const SizedBox(width: 20.0),
                            Column(
                              children: [
                                FBadgeWidget(size: 48.0),
                                const SizedBox(height: 5.0),
                                FText(badge.title!, style: textTheme.bodyMedium),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GoalEditCard extends StatelessWidget {
  const GoalEditCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserRecordP>();

    return FCard(
      title: FText(
        '목표 수정',
        style: textTheme.bodyMedium,
        color: FTheme.lightGrey,
        bold: true,
      ),
      icon: const Icon(Icons.edit),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 60.0,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ActivityType.activeValues.length,
              itemBuilder: (context, index) {
                ActivityType type = ActivityType.activeValues[index];
                Record? record = userP.loggedUser.getGoal(type);
                if (record == null) return Container();

                return SizedBox(
                  width: 70.0.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FText(type.kr, style: textTheme.bodyLarge),
                      FText('${toLocalString(record.amount.round())}${type.unit}',
                        color: type.color,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => VerticalDivider(
                color: FTheme.stroke,
                thickness: .5,
                width: 25.0.w,
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
        '정보 수정',
        style: textTheme.bodyMedium,
        color: FTheme.lightGrey,
        bold: true,
      ),
      icon: const Icon(Icons.edit),
      onPressed: InfoEditP.toInfoEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText('닉네임', style: textTheme.bodyMedium, color: FTheme.lightGrey),
              const SizedBox(height: 5.0),
              FText(userP.loggedUser.nickname!),
            ],
          ),
          const SizedBox(height: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText('신장', style: textTheme.bodyMedium, color: FTheme.lightGrey),
              const SizedBox(height: 5.0),
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
          const SizedBox(height: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText('체중', style: textTheme.bodyMedium, color: FTheme.lightGrey),
              const SizedBox(height: 5.0),
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