import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OnboardingPage extends FPage {
  const OnboardingPage({super.key});

  @override
  FPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends FPageState {
  @override
  OnboardingPageCont get cont => OnboardingPageCont.to;

  TextStyle? get titleStyle => FTheme.headlineMedium;

  CarouselOptions get _options => CarouselOptions(
    height: double.infinity,
    initialPage: 0,
    reverse: false,
    enableInfiniteScroll: false,
    viewportFraction: 1.0,
    onPageChanged: cont.onPageChanged,
  );

  DotsDecorator get _decorator => DotsDecorator(
    color: FTheme.bar,
    activeColor: FTheme.text,
    size: Size(10.0.r, 10.0.r),
    activeSize: Size(150.0.r, 10.0.r),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0.r),
    ),
  );

  Widget _buildBackgroundImageWidget(BuildContext context, int index) {
    return SvgPicture.asset(
      cont.assets[index],
      height: 300.0.h,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _buildTextWidget(BuildContext context, int index) {
    return Column(
      children: [
        FText(
          cont.messages[index],
          maxLines: 3,
          style: titleStyle,
          align: TextAlign.center,
          color: FTheme.text,
        ),
        if (index == 3)
        Padding(
          padding: EdgeInsets.only(top: 10.0.h),
          child: FCommentText(
            cont.comment,
            maxLines: 2,
            align: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildOneCarouselPortraitWidget(BuildContext context, int index) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 130.0.h,
            child: _buildTextWidget(context, index),
          ),
          _buildBackgroundImageWidget(context, index),
        ],
      ),
    );
  }

  Widget _buildOneCarouselLandscapeWidget(BuildContext context, int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 70.0.w,
          child: _buildBackgroundImageWidget(context, index),
        ),
        Positioned(
          right: 40.0.w,
          child: _buildTextWidget(context, index),
        ),
      ],
    );
  }

  Widget _buildOneCarouselWidget(BuildContext context, int index) {
    return PageCont.isPortrait
        ? _buildOneCarouselPortraitWidget(context, index)
        : _buildOneCarouselLandscapeWidget(context, index);
  }

  Widget _buildCarouselWidget(BuildContext context) {
    return CarouselSlider(
      carouselController: cont.carouselCont,
      items: List.generate(
        cont.itemCount,
        (i) => _buildOneCarouselWidget(context, i),
      ),
      options: _options,
    );
  }

  Widget _buildCarouselIndicator(BuildContext context) {
    return Obx(() => DotsIndicator(
      dotsCount: cont.itemCount,
      position: cont.pageIndex.toDouble(),
      decorator: _decorator,
    ));
  }

  Widget _buildStartButton(BuildContext context) {
    return Obx(() => cont.buttonVisible ? FButton(
      key: FButton.ancestorKey,
      onPressed: cont.onStartButtonPressed,
      text: cont.buttonText,
      stretch: true,
    ) : Container());
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      backgroundColor: FTheme.backgroundAlt,
      autoPadding: false,
      body: _buildCarouselWidget(context),
      bottomWidget: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildCarouselIndicator(context),
          _buildStartButton(context),
        ],
      ),
    );
  }

}
