import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LevelDetailPage extends FPage {
  const LevelDetailPage({super.key});

  @override
  FPageState<LevelDetailPage> createState() => _LevelDetailPageState();
}

class _LevelDetailPageState extends FPageState<LevelDetailPage> {

  @override
  LevelDetailPageCont get cont => LevelDetailPageCont.to;
  AdventurePageCont get adventureCont => AdventurePageCont.to;

  Widget _buildProgressIndicatorWidget(BuildContext context) {
    return FLinearPercentIndicator(
      percent: cont.level!.getPercent(cont.amount),
      progressColor: adventureCont.activeType.color,
      backgroundColor: FTheme.achro95.withOpacity(.5),
      centerText: cont.centerText,
      animation: true,
      animateFromLastPercent: true,
    );
  }

  Widget _buildLevelInfoWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: FText(
                cont.level!.title,
                style: FTheme.headlineMedium,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 10.0.w),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 7.0.w, vertical: 1.0.h,
              ),
              decoration: BoxDecoration(
                color: FTheme.achro95.withOpacity(.3),
                borderRadius: BorderRadius.circular(8.0.r),
              ),
              child: FText(
                'LV ${cont.level!.lv}',
                bold: true,
                color: cont.level!.type.color,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0.h),
        FText(
          cont.level!.description,
          style: FTheme.titleSmall,
          maxLines: 0,
        ),
        SizedBox(height: 40.0.h),
        _buildProgressIndicatorWidget(context),
        SizedBox(height: 30.0.h),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.level == null) return Container();
      return Column(
        children: [
          Expanded(
            child: FIslandWidget(
              level: cont.level!,
              width: 170.0.r,
            ),
          ),
          _buildLevelInfoWidget(context),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FScaffold(
        appBar: FAppBar(),
        extendBodyBehindAppBar: true,
        backgroundColor: FTheme.isLightMode
            ? FTheme.sea
            : FTheme.darkSea,
        body: _buildBody(context),
      ),
    );
  }



}
