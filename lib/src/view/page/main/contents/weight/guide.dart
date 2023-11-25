import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeightGuidePage extends FPage {
  const WeightGuidePage({super.key});

  @override
  FPageState<WeightGuidePage> createState() => _WeightGuidePageState();
}

class _WeightGuidePageState extends FPageState<WeightGuidePage> {
  @override
  WeightGuidePageCont get cont => WeightGuidePageCont.to;

  CarouselOptions get _options => CarouselOptions(
    height: PageCont.size.height * .65,
    viewportFraction: 1.0,
    enableInfiniteScroll: false,
    initialPage: cont.pageCount,
    onPageChanged: cont.onPageChanged,
  );

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.exercise == null) return Container();
      return Column(
        children: [
          SizedBox(height: 28.0.h),
          CarouselSlider(
            carouselController: cont.carouselCont,
            items: List.generate(cont.pageCount, (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0.r),
                child: Column(
                  children: [
                    Image.asset(
                      cont.assets[index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.0.r),
                        color: ThemeCont.achro5,
                        child: FText(
                          cont.messages[index],
                          color: ThemeCont.achro95,
                          style: ThemeCont.to.titleSmall,
                          align: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )).toList(),
            options: _options,
          ),
        ],
      );
    });
  }

  DotsDecorator get _decorator => DotsDecorator(
    color: ThemeCont.to.bar,
    activeColor: ThemeCont.to.text,
    size: Size(10.0.r, 10.0.r),
    activeSize: Size(100.0.r, 10.0.r),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0.r),
    ),
  );

  Widget _buildCarouselIndicator(BuildContext context) {
    return Obx(() => DotsIndicator(
      dotsCount: cont.pageCount,
      position: cont.pageIndex.toDouble(),
      decorator: _decorator,
    ));
  }

  Widget _buildOkButton(BuildContext context) {
    return FButton(
      stretch: true,
      text: cont.okButtonText,
      onPressed: cont.okButtonPressed,
    );
  }

  Widget _buildBottomWidget(BuildContext context) {
    return Obx(() => Stack(
      children: [
        _buildCarouselIndicator(context),
        if (cont.isLastPage)
        _buildOkButton(context),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() => FScaffold(
      autoPadding: false,
      appBar: FAppBar(
        text: cont.appBarTitle,
        actions: [
          FTextButton(
            text: 'SKIP',
            onPressed: cont.skipButtonPressed,
          ),
        ],
      ),
      body: _buildBody(context),
      bottomWidget: _buildBottomWidget(context),
    ));
  }
}
