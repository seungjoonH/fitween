import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class GoalSettingPage extends FPage {
  const GoalSettingPage({super.key});

  @override
  FPageState createState() => _GoalSettingPageState();
}

class _GoalSettingPageState extends FPageState {
  @override
  GoalSettingPageCont get cont => GoalSettingPageCont.to;

  TextStyle? get mainStyle => FTheme.displaySmall;

  Widget _buildBackgroundImageWidget(BuildContext context, int index) {
    return SvgPicture.asset(
      cont.assets[index],
      width: PageCont.isPortrait
          ? null : PageCont.size.width * .3,
    );
  }

  Widget _buildSettingIntroCarouselWidget(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FTexts(
        cont.getText(0),
        style: mainStyle,
        highlightColor: FTheme.colorA,
      ),
    );
  }

  Widget _buildDistanceRecommendTextWidget(BuildContext context) {
    return FTexts(
      cont.getText(1),
      style: mainStyle,
      highlightColors: [
        FTheme.colorA,
        FTheme.colorA,
        FType.distance.color,
      ],
    );
  }

  Widget _buildOneCarouselWidget(
    BuildContext context, {
      Widget? leftTopWidget,
      Widget? rightBottomWidget,
      Widget? backgroundImageWidget,
  }) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (backgroundImageWidget != null)
        Positioned(
          right: 10.0.w, bottom: 130.0.h,
          child: backgroundImageWidget,
        ),
        if (leftTopWidget != null)
        Positioned(
          left: .0, top: 80.0.h,
          child: leftTopWidget,
        ),
        if (rightBottomWidget != null)
        Positioned(
          right: .0, bottom: 120.0.h,
          child: rightBottomWidget,
        ),
      ],
    );
  }

  Widget _buildDistanceRecommendCarouselWidget(BuildContext context) {
    return _buildOneCarouselWidget(context,
      leftTopWidget: _buildDistanceRecommendTextWidget(context),
      backgroundImageWidget: _buildBackgroundImageWidget(context, 1),
    );
  }

  Widget _buildUpDownButton(BuildContext context, bool isUp, FType type) {
    int value = cont.getValue(type);
    return FIconButton(
      onPressed: isUp
          ? () => cont.onChanged(value + 1, type)
          : () => cont.onChanged(value - 1, type),
      iconColor: type == FType.height
          ? FTheme.achro20 : FTheme.text,
      icon: Icon(isUp ? Icons.arrow_drop_down : Icons.arrow_drop_up),
    );
  }

  Widget _buildNumberPickerWidget(BuildContext context, FType type) {
    return Obx(() {
      int minValue = cont.getMin(type);
      int maxValue = cont.getMax(type);
      int value = cont.getValue(type);

      bool cannotUp = cont.getMax(type) == value;
      bool cannotDown = cont.getMin(type) == value;

      void onChanged(int v) => cont.onChanged(v, type);

      TextStyle? style = FTheme
          .displayLarge?.copyWith(
        color: type == FType.height
            ? FTheme.achro60
            : FTheme.comment,
      );
      TextStyle? selectedStyle = FTheme
          .largeText.copyWith(color: type.color);

      return Padding(
        padding: PageCont.isLandscape ? EdgeInsets.only(
          left: 50.0.w, right: 8.0.w,
        ) : EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            cannotDown
                ? const SizedBox(child: FIconButton())
                : _buildUpDownButton(context, false, type),
            Align(
              alignment: Alignment.center,
              heightFactor: .6,
              child: ClipRect(
                clipper: _NumberPickerClipper(),
                clipBehavior: Clip.antiAlias,
                child: NumberPicker(
                  haptics: true,
                  minValue: minValue,
                  maxValue: maxValue,
                  value: value,
                  onChanged: onChanged,
                  itemCount: 3,
                  itemWidth: 150.0.r,
                  itemHeight: 70.0.r,
                  textStyle: style,
                  selectedTextStyle: selectedStyle,
                ),
              ),
            ),
            cannotUp
                ? const SizedBox(child: FIconButton())
                : _buildUpDownButton(context, true, type),
          ],
        ),
      );
    });
  }

  Widget _buildDistanceGoalTextWidget(BuildContext context) {
    FType type = FType.distance;
    TextStyle style = mainStyle!.copyWith(color: FTheme.text);
    return Obx(() => FTexts(
      cont.getText(2),
      style: mainStyle,
      highlightStyles: [
        style.copyWith(color: FTheme.colorA),
        mainStyle!.copyWith(color: type.color),
        FTheme.titleSmall!.copyWith(color: style.color),
      ],
      align: TextAlign.end,
    ));
  }

  Widget _buildDistanceGoalCommentWidget(BuildContext context) {
    return Obx(() => FTexts(
      '* ${cont.getComment(2)}',
      style: FTheme.commentStyle,
      textColor: FTheme.comment,
      highlightColor: FType.distance.color,
      mainAxisAlignment: MainAxisAlignment.end,
    ));
  }

  Widget _buildDistanceGoalCarouselWidget(BuildContext context) {
    return _buildOneCarouselWidget(context,
      leftTopWidget: _buildNumberPickerWidget(context, FType.distance),
      rightBottomWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildDistanceGoalTextWidget(context),
          SizedBox(height: 20.0.h),
          _buildDistanceGoalCommentWidget(context),
        ],
      ),
    );
  }

  Widget _buildHeightRecommendTextWidget(BuildContext context) {
    return FTexts(
      cont.getText(3),
      style: mainStyle,
      highlightColors: [
        FTheme.colorA,
        FType.height.color,
      ],
    );
  }

  Widget _buildHeightRecommendCarouselWidget(BuildContext context) {
    return _buildOneCarouselWidget(context,
      leftTopWidget: _buildHeightRecommendTextWidget(context),
      backgroundImageWidget: _buildBackgroundImageWidget(context, 3),
    );
  }

  Widget _buildHeightGoalTextWidget(BuildContext context) {
    FType type = FType.height;
    TextStyle style = mainStyle!.copyWith(color: FTheme.text);
    return Obx(() => FTexts(
      cont.getText(4),
      style: mainStyle,
      highlightStyles: [
        style.copyWith(color: FTheme.colorA),
        mainStyle!.copyWith(color: type.color),
        FTheme.titleSmall!.copyWith(color: style.color),
      ],
      align: TextAlign.start,
    ));
  }

  Widget _buildHeightGoalCommentWidget(BuildContext context) {
    return Obx(() => FTexts(
      '* ${cont.getComment(4)}',
      style: FTheme.commentStyle,
      textColor: FTheme.comment,
      highlightColor: FType.height.color,
      mainAxisAlignment: MainAxisAlignment.end,
    ));
  }

  Widget _buildHeightGoalCarouselWidget(BuildContext context) {
    return _buildOneCarouselWidget(context,
      leftTopWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeightGoalTextWidget(context),
          SizedBox(height: 20.0.h),
          _buildHeightGoalCommentWidget(context),
        ],
      ),
      rightBottomWidget: _buildNumberPickerWidget(context, FType.height),
      backgroundImageWidget: _buildBackgroundImageWidget(context, 4),
    );
  }

  Widget _buildWeightRecommendTextWidget(BuildContext context) {
    return FTexts(
      cont.getText(5),
      style: mainStyle,
      highlightColors: [
        FTheme.colorA,
        FType.weight.color,
      ],
    );
  }

  Widget _buildWeightRecommendCarouselWidget(BuildContext context) {
    return _buildOneCarouselWidget(context,
      leftTopWidget: _buildWeightRecommendTextWidget(context),
      backgroundImageWidget: _buildBackgroundImageWidget(context, 5),
    );
  }

  Widget _buildWeightGoalTextWidget(BuildContext context) {
    FType type = FType.weight;
    TextStyle style = mainStyle!.copyWith(color: FTheme.text);
    return Obx(() => FTexts(
      cont.getText(6),
      style: mainStyle,
      highlightStyles: [
        style.copyWith(color: FTheme.colorA),
        mainStyle!.copyWith(color: type.color),
        FTheme.titleSmall!.copyWith(color: style.color),
      ],
      align: TextAlign.end,
    ));
  }

  Widget _buildWeightGoalCommentWidget(context) {
    return Obx(() => FTexts(
      '* ${cont.getComment(6)}',
      style: FTheme.commentStyle,
      textColor: FTheme.comment,
      highlightColor: FType.weight.color,
      mainAxisAlignment: MainAxisAlignment.end,
    ));
  }

  Widget _buildWeightGoalCarouselWidget(BuildContext context) {
    return _buildOneCarouselWidget(context,
      leftTopWidget: _buildNumberPickerWidget(context, FType.weight),
      rightBottomWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildWeightGoalTextWidget(context),
          SizedBox(height: 20.0.h),
          _buildWeightGoalCommentWidget(context),
        ],
      ),
    );
  }

  Widget _buildFinalCheckFirstTextWidget(BuildContext context) {
    return Obx(() => FTexts(
      cont.getText(7).split('\n\n').first,
      style: mainStyle,
      highlightColors: [
        FTheme.colorA,
        FType.distance.color,
        FType.height.color,
        FType.weight.color,
      ],
    ));
  }

  Widget _buildFinalCheckSecondTextWidget(BuildContext context) {
    return FText(
      cont.getText(7).split('\n\n').last,
      style: mainStyle,
    );
  }

  Widget _buildFinalCheckCommentWidget(BuildContext context) {
    return FCommentText(cont.getComment(7));
  }

  Widget _buildFinalCheckCarouselPortraitWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 120.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFinalCheckFirstTextWidget(context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildFinalCheckSecondTextWidget(context),
              SizedBox(height: 20.0.h),
              _buildFinalCheckCommentWidget(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalCheckCarouselLandscapeWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 200.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(flex: 4, child: _buildFinalCheckFirstTextWidget(context)),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildFinalCheckSecondTextWidget(context),
                SizedBox(height: 20.0.h),
                _buildFinalCheckCommentWidget(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalCheckCarouselWidget(BuildContext context) {
    return PageCont.isPortrait
        ? _buildFinalCheckCarouselPortraitWidget(context)
        : _buildFinalCheckCarouselLandscapeWidget(context);
  }

  EdgeInsets get _padding => EdgeInsets.symmetric(
    horizontal: 28.0.w, vertical: 28.0.h,
  );

  List<Widget> _buildCarouselWidgets(BuildContext context) => [
    _buildSettingIntroCarouselWidget(context),
    _buildDistanceRecommendCarouselWidget(context),
    _buildDistanceGoalCarouselWidget(context),
    _buildHeightRecommendCarouselWidget(context),
    _buildHeightGoalCarouselWidget(context),
    _buildWeightRecommendCarouselWidget(context),
    _buildWeightGoalCarouselWidget(context),
    _buildFinalCheckCarouselWidget(context),
  ].map((w) => Padding(padding: _padding, child: w)).toList();

  @override
  void initState() {
    super.initState();
    cont.init();
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      autoPadding: false,
      backgroundColor: FTheme.backgroundAlt,
      appBar: FAppBar(backPressed: cont.backButtonPressed),
      extendBodyBehindAppBar: true,
      body: CarouselSlider(
        carouselController: cont.carouselCont,
        items: _buildCarouselWidgets(context),
        options: cont.carouselOptions,
      ),
      bottomWidget: Obx(() => FButton(
        text: cont.nextButtonText,
        stretch: true,
        onPressed: cont.nextButtonPressed,
      )),
    );
  }
}

class _NumberPickerClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    Offset center = Offset(size.width  * .5, size.height * .5);
    return Rect.fromCenter(center: center, width: 150.0.r, height: 140.0.r);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}