import 'dart:math';

import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/page/contents/workout/battle/record.dart';
import 'package:fitween/presenter/page/contents/workout/battle/result.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/icon.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BattleRecordPage extends StatelessWidget {
  const BattleRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FAppBar(title: '최근 전적'),
      body: GetBuilder<BattleRecordP>(
        builder: (battleRecordP) {
          final userP = Get.find<UserInfoP>();

          return SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 28.0.w,
                  vertical: 28.0.h,
                ),
                child: Column(
                  children: [
                    FCard(
                      backgroundColor: FTheme.colorA.withOpacity(.5),
                      borderColor: FTheme.colorA,
                      borderWidth: 3.0,
                      title: Row(
                        children: [
                          FText(
                            userP.loggedUser.nickname!,
                            style: textTheme(context).titleSmall,
                            color: FTheme.darkGrey,
                            bold: true,
                          ),
                          FText(' 님의 전적',
                            style: textTheme(context).titleSmall,
                            color: FTheme.darkGrey,
                          ),
                        ],
                      ),
                      child: Builder(
                        builder: (context) {
                          int win = battleRecordP.win;
                          int lose = battleRecordP.lose;
                          int draw = battleRecordP.draw;
                          double rate = win / max(1, win + lose + draw);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FTexts(
                                ['$win승', ':', '$draw무', ':', '$lose패'],
                                colors: const [
                                  FTheme.colorC, FTheme.darkGrey,
                                  FTheme.colorD, FTheme.darkGrey,
                                  FTheme.colorB
                                ],
                                style: textTheme(context).headlineMedium,
                                bold: true,
                              ),
                              FText(
                                '승률 ${(rate * 100).toStringAsFixed(1)}%',
                                style: textTheme(context).titleSmall,
                                color: FTheme.darkGrey,
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      children: battleRecordP.battles.map((battle) {
                        String myUid = userP.loggedUser.uid!;
                        String rivalUid = battle.memberInfos
                            .keys.firstWhere((uid) => uid != myUid);
                        FUserInfo rival = battle.memberInfos[rivalUid]!;

                        Duration over = now.difference(battle.genDate!);
                        late String overString;
                        if (over.inDays > 0) { overString = '${over.inDays}일 전'; }
                        else if (over.inHours > 0) { overString = '${over.inHours}시간 전'; }
                        else if (over.inMinutes > 0) { overString = '${over.inMinutes}분 전'; }
                        else if (over.inSeconds > 0) { overString = '${over.inSeconds}초 전'; }

                        late Color leftColor, rightColor;
                        if (battle.won(userP.loggedUser.uid!)) {
                          leftColor = FTheme.colorC;
                          rightColor = FTheme.colorB;
                        }
                        if (battle.defeated(userP.loggedUser.uid!)) {
                          leftColor = FTheme.colorB;
                          rightColor = FTheme.colorC;
                        }
                        if (battle.tied) {
                          leftColor = FTheme.colorD;
                          rightColor = FTheme.colorD;
                        }

                        return Column(
                          children: [
                            FCard(
                              constraints: const BoxConstraints(minHeight: 100.0),
                              onPressed: () => BattleResultP.toBattleResult(battle.id!, offAll: false),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FText(overString,
                                    color: FTheme.lightGrey,
                                    style: textTheme(context).labelMedium,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Align(
                                          alignment: Alignment.centerRight,
                                          child: MeTag(),
                                        ),
                                        const SizedBox(width: 10.0),
                                        FBadgeWidget(
                                          defeated: battle.defeated(myUid),
                                          backgroundColor: leftColor,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                                          child: FIcon(FIcons.swords, selected: true),
                                        ),
                                        FBadgeWidget(
                                          defeated: battle.defeated(rivalUid),
                                          backgroundColor: rightColor,
                                        ),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: FText(rival.nickname!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
