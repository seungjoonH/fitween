import 'package:animated_digit/animated_digit.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeightCompletePage extends FPage {
  const WeightCompletePage({super.key});

  @override
  FPageState<WeightCompletePage> createState() => _WeightCompletePageState();
}

class _WeightCompletePageState extends FPageState<WeightCompletePage> {

  @override
  WeightCompletePageCont get cont => WeightCompletePageCont.to;

  Widget _buildAnimatedTextWidget(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedDigitWidget(
          value: cont.afterAmount,
          textStyle: ThemeCont.to.largeText
              .copyWith(color: FType.weight.color),
          suffix: FType.weight.onlyUnit(cont.count),
        ),
        FText(
          '/${FType.weight.withUnit(cont.goalAmount)}',
          style: ThemeCont.to.titleLarge,
          color: ThemeCont.to.comment,
        ),
      ],
    ));
  }

  Widget _buildRecordGraphWidget(BuildContext context) {
    return Obx(() => Stack(
      children: [
        FLinearPercentIndicator(
          percent: cont.afterPercent,
          backgroundColor: ThemeCont.to.background,
          progressColor: FType.weight.color.withOpacity(.5),
          animation: true,
        ),
        FLinearPercentIndicator(
          percent: cont.beforePercent,
          backgroundColor: Colors.transparent,
          progressColor: FType.weight.color,
        ),
        Positioned.fill(
          child: Row(
            children: [
              Expanded(flex: cont.originLeftFlex, child: const SizedBox()),
              FText(
                FType.weight.withUnit(cont.beforeAmount),
                style: ThemeCont.to.bodyMedium,
                color: ThemeCont.achro95,
                bold: true,
              ),
              Expanded(flex: cont.originRightFlex, child: const SizedBox()),
            ],
          ),
        ),
        Positioned.fill(
          child: Row(
            children: [
              Expanded(flex: cont.addedLeftFlex, child: const SizedBox()),
              FText('+${FType.weight.withUnit(cont.count)}', style: ThemeCont.to.bodyMedium),
              Expanded(flex: cont.addedRightFlex, child: const SizedBox()),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildIncreasingFigureWidget(BuildContext context) {
    return Column(
      children: [
        _buildAnimatedTextWidget(context),
        SizedBox(height: 20.0.h),
        _buildRecordGraphWidget(context),
      ],
    );
  }

  Widget _buildRecordCardWidget(BuildContext context) {
    return FCard(
      title: FText(cont.myRecordText, style: ThemeCont.to.cardTitleStyle),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText(
            cont.increasedText,
            color: ThemeCont.to.comment,
            style: ThemeCont.to.commentStyle,
          ),
          SizedBox(height: 20.0.h),
          _buildIncreasingFigureWidget(context),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildRecordCardWidget(context),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
      bottomWidget: FButton(
        stretch: true,
        text: cont.completeButtonText,
        onPressed: cont.completeButtonPressed,
      ),
    );
  }

}
