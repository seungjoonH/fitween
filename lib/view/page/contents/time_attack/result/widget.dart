import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widget/button/button.dart';
import '../../../../widget/widget/card.dart';
import '../../../../widget/widget/text.dart';

class TimeAttackResultView extends StatelessWidget {
  const TimeAttackResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FinishCard(),
          BattleResultCard(),
        ],
      ),
    );
  }
}

class FinishCard extends StatelessWidget {
  const FinishCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
      child: FCard(
          child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                  child: Image.asset(
                      'assets/image/page/contents/time_attack/resultBig.png')),
              Positioned(
                bottom: 35.0.h,
                child: FText(
                  '42회',
                  color: FTheme.white,
                  style: FTheme.textTheme.displayMedium,
                ),
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          FButton(
            stretch: true,
            text: '타임어택 완료!',
            backgroundColor: FTheme.colorA,
          )
        ],
      )),
    );
  }
}

class BattleResultCard extends StatelessWidget {
  const BattleResultCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
      child: FCard(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText(
            '대결 결과',
            style: FTheme.textTheme.titleLarge,
            bold: true,
            color: FTheme.darkGrey,
          ),
          SizedBox(
            height: 10,
          ),
          FText('하쿠나 님이 승리하셨어요!', style: FTheme.textTheme.bodyLarge, color: FTheme.grey,),
        ],
      )),
    );
  }
}
