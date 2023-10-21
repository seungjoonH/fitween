import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FPointPage extends FPage {
  const FPointPage({super.key});

  @override
  FPageState<FPointPage> createState() => _FPointPageState();
}

class _FPointPageState extends FPageState<FPointPage> {

  @override
  FPointPageCont get cont => FPointPageCont.to;
  FPointCont get pointCont => FPointCont.to;

  Widget _buildBackgroundColorWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FTheme.point.withOpacity(.0),
            FTheme.background,
          ],
        ),
      ),
    );
  }

  Widget _buildFPointButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FPointIcon(size: 25.0.r),
          SizedBox(width: 5.0.w),
          SizedBox(
            height: 80.0.h,
            child: Obx(() => AnimatedFlipCounter(
              value: cont.fPoint,
              suffix: ' FP',
              thousandSeparator: ',',
              duration: 1.s,
              textStyle: FTheme.headlineMedium
                  ?.copyWith(color: FTheme.point),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSilverAppBarWidget(BuildContext context) {
    return SliverAppBar(
      leading: Container(),
      expandedHeight: 120.0.h,
      flexibleSpace: FlexibleSpaceBar(
        title: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildBackgroundColorWidget(context),
            _buildFPointButtonWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingCircleWidget(BuildContext context, PointHistoryData data) {
    Color color = data.earned ? FTheme.colorB : FTheme.colorC;
    Color blended = Color.alphaBlend(color, FTheme.background);

    return Container(
      width: 45.0.r,
      height: 45.0.r,
      decoration: BoxDecoration(
        color: blended,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: FText(
        data.amountWithSign,
        color: FTheme.achro95,
        style: FTheme.bodySmall,
        bold: true,
      ),
    );
  }

  Widget _buildSliverListWidget(BuildContext context) {
    return SliverList.list(
      children: pointCont.pointHistory.map((h) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 50.0.w,
              child: FText(
                now.difference(h.date).ago,
                style: FTheme.bodyMedium,
                color: FTheme.comment,
              ),
            ),
            SizedBox(width: 10.0.w),
            Expanded(
              child: FText(
                h.content,
                bold: true,
                style: FTheme.bodyLarge,
                maxLines: 0,
              ),
            ),
            _buildLeadingCircleWidget(context, h),
          ],
        ),
      )).separateH(height: 10.0.h),
    );
  }

  Widget _buildSliverWidget(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        _buildSilverAppBarWidget(context),
        _buildSliverListWidget(context),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      autoPadding: false,
      appBar: FAppBar(),
      extendBodyBehindAppBar: true,
      body: _buildSliverWidget(context),
    );
  }

}
