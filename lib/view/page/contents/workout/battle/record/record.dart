import 'dart:math';

import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/presenter/lang/language.dart';
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
      appBar: FAppBar(title: Lang.tr('btl.history.rcnt')),
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
                      title: FTextsT(
                        Lang.tr(
                          'btl.history.title',
                          args: [userP.loggedUser.nickname!],
                        ),
                        style: textTheme(context).titleSmall,
                        highlightStyles: [
                          textTheme(context).titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
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
                              FTextsT(
                                '@{$win${Lang.tr('btl.history.win')}} : @{$draw${Lang.tr('btl.history.tie')}} : @{$lose${Lang.tr('btl.history.lose')}}',
                                style: textTheme(context).headlineMedium,
                                highlightColors: const [
                                  FTheme.colorC, FTheme.colorD, FTheme.colorB
                                ],
                              ),
                              FText(
                                Lang.tr('btl.history.odds', args: [(rate * 100).toStringAsFixed(1)]),
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

                        String agoString = now.difference(battle.genDate!).ago;

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
                                  FText(agoString,
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
