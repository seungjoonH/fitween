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
      backgroundColor: ThemeCont.achro95.withOpacity(.5),
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
                style: ThemeCont.to.headlineMedium,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 10.0.w),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 7.0.w, vertical: 1.0.h,
              ),
              decoration: BoxDecoration(
                color: ThemeCont.achro95.withOpacity(.3),
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
          style: ThemeCont.to.titleSmall,
          maxLines: 0,
        ),
        SizedBox(height: 40.0.h),
        _buildProgressIndicatorWidget(context),
        SizedBox(height: 30.0.h),
      ],
    );
  }

  double get _defaultSize => 50.0.r;

  Widget _buildBadgeWidget(BuildContext context) {
    return Obx(() {
      if (!cont.compensationBadgeAvailable) return Container();

      if (cont.isCurrent) {
        return FBadgeWidget(
          badge: cont.compensationBadge,
          size: _defaultSize,
          disable: true,
          border: true,
          pressable: false,
          longPressable: false,
        );
      }

      else if (cont.badgeCanBeEarned) {
        return PulseWidget(
          onPressed: cont.badgePressed,
          child: FBadgeWidget(
            badge: cont.compensationBadge,
            size: _defaultSize,
            disable: false,
            border: true,
            pressable: false,
            longPressable: false,
          ),
        );
      }

      return Stack(
        alignment: Alignment.topRight,
        children: [
          FBadgeWidget(
            badge: cont.compensationBadge,
            size: _defaultSize,
            disable: false,
            border: true,
            pressable: true,
            longPressable: true,
          ),
          Positioned(
            top: 5.0.r, right: 5.0.r,
            child: Icon(
              Icons.check_circle,
              color: cont.compensationBadge!.ftype!.color,
              size: 20.0.r,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildItemWidget(BuildContext context) {
    return ItemCellWidget(size: _defaultSize);
  }

  Widget _buildCompensationsWidget(BuildContext context) {
    return Row(
      children: [
        _buildBadgeWidget(context),
        SizedBox(width: 10.0.w),
        _buildItemWidget(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.level == null) return Container();
      return Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: FIslandWidget(
                  level: cont.level!,
                  width: 170.0.r,
                ),
              ),
              _buildLevelInfoWidget(context),
            ],
          ),
          Positioned(
            right: .0, top: 50.0.h,
            child: _buildCompensationsWidget(context),
          ),
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
    return FScaffold(
      appBar: FAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: ThemeCont.to.isLightMode
          ? ThemeCont.sea
          : ThemeCont.darkSea,
      body: _buildBody(context),
    );
  }



}
