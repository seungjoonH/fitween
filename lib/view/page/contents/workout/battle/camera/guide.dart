import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/presenter/page/contents/workout/battle/guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';

class WorkoutGuidePage extends StatelessWidget {
  const WorkoutGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FAppBar(),
      body: Center(
        child: CarouselSlider(
          items: List.generate(4, (index) => Padding(
            padding: const EdgeInsets.fromLTRB(30.0, .0, 30.0, 30.0),
            child: GuideCard(index: index),
          ))..add(Center(
            child: PButton(
              text: 'GO!',
              backgroundColor: FTheme.colorD,
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0, vertical: 20.0,
              ),
              // onPressed: BattleCameraP.toBattleCamera,
            ),
          )),
          options: CarouselOptions(
            height: 700.0.h,
            aspectRatio: .8,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
          ),
        ),
      ),
    );
  }
}

class GuideCard extends StatelessWidget {
  const GuideCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FText('<무게 측정 방법>', style: textTheme(context).headlineSmall),
          const SizedBox(height: 10.0),
          Image.asset(
            BattleGuideP.getAsset(index),
            width: 300.0.w,
            height: 400.0.h,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(height: 10.0),
          Container(
            width: 30.0.r,
            height: 30.0.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1.5),
            ),
            child: FText('${index + 1}'),
          ),
          const SizedBox(height: 20.0),
          FText(BattleGuideP.descriptions[index], maxLines: 2),
        ],
      ),
    );
  }
}
