import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
          FPointIcon(size: 35.0.r, isWhite: true),
          SizedBox(width: 5.0.w),
          FText(
            '${fPointCont.fPoint.thouSep} FP',
            style: ThemeCont.to.displaySmall,
            color: ThemeCont.achro95,
          ),
        ],
      ),
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
      child: Container(),
    );
  }

  Widget _buildGoalByTypeWidget(BuildContext context, FType type) {
    return Expanded(
      child: Column(
        children: [
          FText(
            type.locale.capitalize!,
            style: ThemeCont.to.titleSmall,
          ),
          FTexts(
            cont.getGoalTextOf(type),
            style: ThemeCont.to.bodySmall,
            textColor: type.color,
            highlightStyle: ThemeCont.to.titleSmall
                ?.apply(color: type.color),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsWidget(BuildContext context) {
    Widget divider = SizedBox(
      height: 50.0.h,
      child: VerticalDivider(
        width: 10.0.w,
        thickness: .5,
        color: ThemeCont.to.stroke,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: FType.activeValues.map((type) {
        return _buildGoalByTypeWidget(context, type);
      }).separateW(separator: divider),
    );
  }

  Widget _buildGoalSettingCardWidget(BuildContext context) {
    return FCard(
      title: FText(
        cont.goalSettingCardTitle,
        color: ThemeCont.to.comment,
        style: ThemeCont.to.commentStyle,
        bold: true,
      ),
      onPressed: cont.goalSettingCardPressed,
      icon: const Icon(Icons.edit),
      pressMode: FCardPressMode.icon,
      child: _buildGoalsWidget(context),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() => FMainScaffold(
      backgroundColor: ThemeCont.to.background,
      refreshController: RefreshController(),
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
          // _buildMyBadgeCardWidget(context),
          _buildGoalSettingCardWidget(context),
        ].separateH(height: 20.0.h),
      ),
    ));
  }

}