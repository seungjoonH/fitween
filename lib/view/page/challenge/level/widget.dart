import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/challenge/level.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tab_scaffold.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../model/class/database/user/record.dart';
import '../../../../model/class/json/level.dart';
import '../../../../model/enum/activity_type.dart';
import '../../../../model/enum/unit.dart';
import '../../../../presenter/model/level.dart';
import '../../../../presenter/model/record.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/class/json/challenge.dart';
import 'package:fitween/model/enum/border_type.dart';
import 'package:fitween/model/enum/difficulty.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/presenter/model/challenge.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/challenge/detail.dart';
import 'package:fitween/presenter/page/challenge/main.dart';
import 'package:fitween/presenter/page/challenge/party/main.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:fitween/view/widget/widget/card.dart';

class ChallengeLevelPageView extends StatelessWidget {
  const ChallengeLevelPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FUserRecord loggedUser = Get.find<UserRecordP>().loggedUser;
    FUserInfo userInfo = Get.find<UserInfoP>().loggedUser;

    return SingleChildScrollView(
      child: Column(
        children: ActivityType.values.sublist(1, 3).map((type) {
          double amount = loggedUser.getAmounts(type);
          Record record = Record.init(type, amount, ExerciseUnit.step);

          Map<String, dynamic> tier = LevelPresenter.getTier(type, record);
          Level next = tier['next'] ?? Level.fromJson({'amount': 0});

          Record nextValue = Record.init(
            type,
            next.amount!.toDouble(),
            ExerciseUnit.kilometer,
          );

          nextValue.convert(ExerciseUnit.step);

          return Card(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    ChallengeLevelP.toChallengeLevel();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FText(
                          '${userInfo.nickname}님은 지금까지',
                          style: textTheme.bodyMedium,
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
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          width: 300,
                          height: 280,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/image/page/achievement/Union.png',
                                height: 280,
                                width: 300,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 100.0.w,
                                        child: tier['current'] != null
                                            ? Image.asset(
                                          'assets/image/level/${type.name}/${tier['current'].id}.png',
                                          width: 40.0.w,
                                        )
                                            : Container(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FText(
                                          '현재 진행도',
                                          style: textTheme.bodyMedium,
                                          color: FTheme.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 12.0,
                                      ),
                                      child: LinearPercentIndicator(
                                        padding: EdgeInsets.zero,
                                        progressColor: type.color,
                                        backgroundColor: FTheme
                                            .lightGrey, // Colors.transparent,
                                        percent: tier['percent'] ?? .0,
                                        lineHeight: 48.0,
                                        barRadius: Radius.circular(10.0.r),
                                        animation: true,
                                        animationDuration: 1000,
                                        curve: Curves.easeInOut,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FText(
                                          '${tier['percent'].toInt()}%',
                                          style: textTheme.bodyMedium,
                                          color: type.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
    );
  }
}