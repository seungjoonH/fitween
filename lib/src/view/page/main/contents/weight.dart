import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeightPage extends FPage {
  const WeightPage({super.key});

  @override
  FPageState<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends FPageState<WeightPage> {
  @override
  WeightPageCont get cont => WeightPageCont.to;

  Widget _buildGridView(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: .75,
        crossAxisCount: 2,
      ),
      children: [
        _buildExerciseButtonWidget(context, Exercise.squat),
      ],
    );
  }

  Widget _buildExerciseButtonWidget(BuildContext context, Exercise exercise) {
    return DarkPressableWidget(
      onPressed: () => cont.exerciseButtonPressed(exercise),
      child: Container(
        padding: EdgeInsets.all(10.0.r),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5.0.r),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ThemeCont.to.bar,
                  width: 7.0.r,
                ),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  exercise.imageUrl,
                  width: 100.0.r,
                  height: 100.0.r,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FText(
                  exercise.locale.capitalize!,
                  style: ThemeCont.to.titleMedium,
                  bold: true,
                ),
                SizedBox(width: 5.0.w),
                const FTextTag('Beta'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(text: cont.appBarTitle),
      body: Column(
        children: [
          HeaderWidget(text: cont.exerciseText),
          Expanded(child: _buildGridView(context)),
        ],
      ),
    );
  }
}

