import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BadgePage extends FPage {
  const BadgePage({super.key});

  @override
  FPageState<BadgePage> createState() => _BadgePageState();
}

class _BadgePageState extends FPageState<BadgePage> {

  @override
  BadgePageCont get cont => BadgePageCont.to;
  FBadgeCont get badgeCont => FBadgeCont.to;

  Widget? _buildBadgesWidget(BuildContext context, FBadgeType type) {
    if (!badgeCont.hasBadgeOnType(type)) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(text: type.locale),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: badgeCont.getBadgesByType(type).map((badge) => FBadgeDetailedWidget(
              badge: badge,
              size: 60.0.r,
              displayTitle: true,
              displayDate: true,
              displayCount: true,
              displayMain: true,
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    List<Widget?> list = FBadgeType.values
        .map((type) => _buildBadgesWidget(context, type)).toList();
    list.removeWhere((w) => w == null);

    return SingleChildScrollView(
      child: Column(children: list.cast<Widget>().separateH(height: 20.0.h)),
    );
  }
  
  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }
}
