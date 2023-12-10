import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdventurePage extends FPage {
  const AdventurePage({super.key});

  @override
  FPageState<AdventurePage> createState() => _AdventurePageState();
}

class _AdventurePageState extends FPageState<AdventurePage> {
  @override
  AdventurePageCont get cont => AdventurePageCont.to;
  FriendCont get friendCont => FriendCont.to;

  Widget _buildIslandListWidget(BuildContext context, FType type) {
    return Obx(() => Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0.w),
          child: Column(
            children: List.generate(
              cont.list.length, (index) {
                Level level = cont.list[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(flex: cont.getLeftRatio(index), child: const SizedBox()),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        FIslandWidget(
                          level: level,
                          period: cont.getPeriod(index),
                          onPressed: () => cont.islandWidgetPressed(level),
                          hide: !level.isAchievedAmount(cont.amount),
                        ),
                      ],
                    ),
                    Expanded(flex: cont.getRightRatio(index), child: const SizedBox()),
                  ],
                );
              },
            ).separateH(height: 40.0.h),
          ),
        ),
        Positioned(
          top: -550.0.h,
          child: _buildTopCloudImage(context),
        ),
      ],
    ));
  }

  Widget _buildMyProgressWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5.0.w),
      child: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: cont.list.map((level) => Container(
          height: 220.0.r,
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0.r,
              vertical: 2.0.r,
            ),
            decoration: BoxDecoration(
              color: ThemeCont.achro95.withOpacity(.3),
              borderRadius: BorderRadius.circular(5.0.r),
            ),
            child: FText(
              cont.activeType.withUnit(level.amount.main),
              style: ThemeCont.to.bodySmall,
              align: TextAlign.end,
              color: cont.activeType.color
            ),
          ),
        )).separateH(height: 40.0.h),
      )),
    );
  }

  Widget _buildUserPositionedWidget(BuildContext context, FUser user) {
    return FUserWaterDropWidget(
      user: user,
      color: cont.activeType.color,
    );
  }

  Widget _buildFriendProgressWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5.0.w),
      child: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(cont.list.length, (i) {
          Level level = cont.list[i];
          return Container(
            height: i == 0 ? 80.0.r : 200.0.r,
            margin: EdgeInsets.only(bottom: 20.0.r),
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: friendCont.getFollowersInLevel(level)
                  .map((user) => _buildUserPositionedWidget(context, user)).toList(),
            ),
          );
        }).separateH(height: 40.0.h),
      )),
    );
  }

  Widget _buildTopCloudImage(BuildContext context) {
    return Image.asset(
      AdventurePageCont.topCloudAsset,
      fit: BoxFit.fitHeight,
      height: 800.0.h,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          controller: cont.scrollCont,
          child: Container(
            padding: EdgeInsets.only(bottom: 300.0.h),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                _buildIslandListWidget(context, FType.distance),
                _buildMyProgressWidget(context),
                _buildFriendProgressWidget(context),
              ],
            ),
          ),
        ),
        Positioned(
          top: 150.0.h,
          left: .0,
          child: FTypeSelectionButton(
            values: FType.activeValues,
            onChanged: cont.setType,
          ),
        ),
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
      appBar: FAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: ThemeCont.to.isLightMode
          ? ThemeCont.sea
          : ThemeCont.darkSea,
      autoPadding: false,
      body: _buildBody(context),
    );
  }

}