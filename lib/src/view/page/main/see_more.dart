import 'dart:math';

import 'package:animated_digit/animated_digit.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SeeMorePage extends FPage {
  const SeeMorePage({super.key});

  @override
  FWidgetState<FWidget> createState() => _SeeMorePageState();
}

class _SeeMorePageState extends FPageState<SeeMorePage> {
  @override
  SeeMorePageCont get cont => SeeMorePageCont.to;
  NotificationCont get notificationCont => NotificationCont.to;
  FPointCont get fPointCont => FPointCont.to;
  InventoryCont get inventoryCont => InventoryCont.to;
  FBadgeCont get badgeCont => FBadgeCont.to;

  Widget _buildFPointCardWidget(BuildContext context) {
    return FCard(
      title: FText(
        cont.fPointCardTitle,
        color: ThemeCont.achro95,
        style: ThemeCont.to.commentStyle,
        bold: true,
      ),
      iconColor: ThemeCont.achro95,
      pressMode: FCardPressMode.icon,
      onPressed: cont.fPointCardPressed,
      backgroundColor: ThemeCont.to.point,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedDigitWidget(
            value: fPointCont.fPoint,
            enableSeparator: true,
            separateSymbol: ',',
            textStyle: ThemeCont.to.displaySmall
                ?.copyWith(color: ThemeCont.achro95),
          ),
          SizedBox(width: 10.0.w),
          FPointIcon(size: 40.0.r, isWhite: true),
        ],
      ),
    );
  }

  Widget _buildMainBadgeWidget(BuildContext context) {
    return Obx(() {
      if (badgeCont.mainBadge == null) return Container();

      return Column(
        children: [
          FBadgeDetailedWidget(
            badge: badgeCont.mainBadge!,
            size: 75.0.r,
            displayTitle: true,
            displayDate: true,
            pressable: true,
            longPressable: true,
          ),
          SizedBox(height: 10.0.h),
          FTextTag(
            cont.mainText,
            textColor: ThemeCont.to.background,
            backgroundColor: ThemeCont.to.text,
          ),
        ],
      );
    });
  }

  Widget _buildRecentBadgesWidget(BuildContext context) {
    List<FBadge> badgeList = [...badgeCont.badgesWithOutMain];
    badgeList = badgeList.sublist(0, min(2, badgeList.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FText(
          cont.recentText,
          color: ThemeCont.to.comment,
          style: ThemeCont.to.commentStyle,
        ),
        SizedBox(height: 20.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: badgeList.map((badge) => FBadgeDetailedWidget(
            badge: badge,
            displayTitle: true,
            size: 55.0.r,
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildMyBadgeCardWidget(BuildContext context) {
    return FCard(
      title: FText(
        cont.myBadgeCardTitle,
        color: ThemeCont.to.comment,
        style: ThemeCont.to.commentStyle,
        bold: true,
      ),
      pressMode: FCardPressMode.icon,
      onPressed: cont.badgeCardPressed,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildMainBadgeWidget(context),
            ),
            VerticalDivider(
              width: 40.0.w,
              thickness: .5,
              color: ThemeCont.to.stroke,
            ),
            Expanded(
              flex: 3,
              child: _buildRecentBadgesWidget(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCardWidget(BuildContext context) {
    return Obx(() => FCard(
      title: FText(
        cont.inventoryCardTitle,
        color: ThemeCont.to.comment,
        style: ThemeCont.to.commentStyle,
        bold: true,
      ),
      onPressed: cont.inventoryCardPressed,
      pressMode: FCardPressMode.icon,
      child: ItemInventoryWidget(
        itemList: inventoryCont.inventory,
        rowCount: 1,
        columnCount: 3,
      ),
    ));
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() => FMainScaffold(
      backgroundColor: ThemeCont.to.background,
      refreshController: cont.refreshCont,
      onRefresh: cont.onRefresh,
      appBar: FAppBar(
        text: cont.appBarTitle,
        allowLeading: false,
        actions: [
          FIconButton(
            icon: const Icon(Icons.notifications),
            notifications: notificationCont.uncheckedCount,
            onPressed: cont.notificationButtonPressed,
          ),
          FIconButton(
            icon: const Icon(Icons.settings),
            onPressed: cont.settingsButtonPressed,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFPointCardWidget(context),
          _buildMyBadgeCardWidget(context),
          _buildInventoryCardWidget(context),
        ].separateH(height: 20.0.h),
      ),
    ));
  }

}