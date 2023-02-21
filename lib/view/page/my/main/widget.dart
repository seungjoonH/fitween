/* 마이 페이지 위젯 */

import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/class/json/level.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/level.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/my/record/main.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/text.dart';

class MyMainView extends StatefulWidget {
  const MyMainView({Key? key}) : super(key: key);

  @override
  State<MyMainView> createState() => _MyMainViewState();
}

class _MyMainViewState extends State<MyMainView> {
  @override
  Widget build(BuildContext context) {
    FUserRecord loggedUser = Get.find<UserRecordP>().loggedUser;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyProfileWidget(),
            const SizedBox(height: 30.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FText('개인 누적 기록치', style: textTheme.headlineSmall),
                const SizedBox(height: 20.0),
                Column(
                  children: ActivityType.values.sublist(1, 3).map((type) {
                    double amount = loggedUser.getAmounts(type);
                    Record record = Record.init(type, amount, ExerciseUnit.step);

                    Map<String, dynamic> tier = LevelPresenter.getTier(type, record);
                    Level next = tier['next'] ?? Level.fromJson({'amount': 0});

                    Record nextValue = Record.init(
                      type, next.amount!.toDouble(), ExerciseUnit.kilometer,
                    );

                    nextValue.convert(ExerciseUnit.step);
                    int remainValue = (nextValue.amount - amount).round();

                    return SizedBox(
                      height: 130.0.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => MyRecordMain.toMyRecordMain(type),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 70.0.w,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (tier['current'] != null)
                                          Image.asset(
                                            'assets/image/level/${type.name}/${tier['current'].id}.png',
                                            width: 40.0.w,
                                          ),
                                          FText(
                                            tier['current']?.title ?? '',
                                            maxLines: 2,
                                            style: textTheme.bodySmall,
                                            align: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: FTheme.black, width: 1.5),
                                              borderRadius: BorderRadius.circular(20.0.r),
                                            ),
                                            child: LinearPercentIndicator(
                                              padding: EdgeInsets.zero,
                                              progressColor: type.color,
                                              backgroundColor: Colors.transparent,
                                              percent: tier['percent'] ?? .0,
                                              lineHeight: 18.0,
                                              barRadius: Radius.circular(20.0.r),
                                              animation: true,
                                              animationDuration: 1000,
                                              curve: Curves.easeInOut,
                                            ),
                                          ),
                                          FTexts(
                                            ['다음 단계까지', '$remainValue${type.unit}'],
                                            colors: [FTheme.black, type.color],
                                            style: textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60.0,
                                      child: FText(
                                        '${(100 * (tier['percent'] ?? 0)).round()}%',
                                        style: textTheme.headlineSmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                    );
                  }).toList(),
                ),
                SizedBox(height: 180.0.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyProfileWidget extends StatelessWidget {
  const MyProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetBuilder<UserCollectionP>(
          builder: (userP) {
            return BadgeWidget(
              badge: BadgePresenter.getBadge(userP.loggedUser.badgeId),
              size: 80.0.r,
            );
          },
        ),
        SizedBox(width: 30.0.w),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<UserInfoP>(
              builder: (userP) => FText(
                  userP.loggedUser.nickname!,
                  style: textTheme.displaySmall,
                )
            ),
            FText(
              '${userHeight}cm | ${userWeight}kg',
              style: textTheme.titleLarge,
              color: FTheme.darkGrey,
            ),
          ],
        ),
      ],
    );
  }
}
