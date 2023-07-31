import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/contents/workout/friend.dart';
import 'package:fitween/presenter/page/contents/workout/ready.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BattleFriendView extends StatelessWidget {
  const BattleFriendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfoP = Get.find<UserInfoP>();

    return GetBuilder<WorkoutFriendP>(
      builder: (workoutFriendP) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  FTextsT(
                    Lang.tr(
                      'btl.card-cmt',
                      args: [Lang.tr('btl.${ExerciseHandler.workout.local}')],
                    ),
                    style: textTheme(context).titleMedium,
                    highlightStyles: [
                      textTheme(context).titleMedium!.copyWith(
                        color: ActivityType.weight.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0.h),
                  SizedBox(
                    height: 360.0.h,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: workoutFriendP.infos.length,
                      itemBuilder: (context, index) => FCard(
                        borderColor: workoutFriendP.selectedIndex == index ? FTheme.stroke : null,
                        borderWidth: 2.0,
                        onPressed: () => workoutFriendP.select(index),
                        child: Row(
                          children: [
                            FBadgeWidget(
                              badge: BadgeJsonP.getBadge(workoutFriendP.collections[index].badgeId),
                              backgroundColor: workoutFriendP.collections[index].badgeColor,
                            ),
                            const SizedBox(width: 20.0),
                            FText(workoutFriendP.infos[index].nickname!),
                            if (workoutFriendP.infos[index].uid == userInfoP.loggedUser.uid)
                            Row(
                              children: [
                                const MeTag(),
                                FTag(Lang.tr('btl.solo')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(height: 20.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: FButton(
                  text: Lang.tr('btn.slct'),
                  stretch: true,
                  onPressed: WorkoutReadyP.toWorkoutReady,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class FriendCard extends StatelessWidget{
  const FriendCard(this.name,{Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 87,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: FTheme.white
        ),
        margin: const EdgeInsets.only(top: 7),
        child: Row(
          children: [
            /*BadgeWidget(
              badge: BadgeJsonP.getBadge(controller.loggedUser.badgeId),
              size: 80.0.r,
            ),*/
            const SizedBox(
              width: 18,
            ),
            Image.asset('assets/image/badge/1000000.png', height: 48, width: 48),
            const SizedBox(width: 12.0, height: 90.0),
            FText(
              name,
              style: textTheme(context).labelLarge,
              color: FTheme.darkGrey,
            ),
          ],
        ),
      ),
    );
  }
}

