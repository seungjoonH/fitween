import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContentsPage extends FPage {
  const ContentsPage({super.key});

  @override
  FPageState<ContentsPage> createState() => _ContentsPageState();
}

class _ContentsPageState extends FPageState<ContentsPage> {
  @override
  ContentsPageCont get cont => ContentsPageCont.to;

  Widget _buildContentsCardWidget(Content content) {
    return FCard(
      backgroundWidget: SvgPicture.asset(
        content.path,
        fit: BoxFit.fitWidth,
      ),
      height: 150.0.h,
      title: FText(
        content.cardTitle,
        style: ThemeCont.to.cardTitleStyle,
        color: ThemeCont.achro95,
      ),
      iconColor: ThemeCont.achro95,
      onPressed: () => cont.contentCardPressed(content),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return FMainScaffold(
      refreshController: RefreshController(),
      appBar: FAppBar(text: cont.appBarTitle),
      onRefresh: cont.onRefresh,
      body: Column(
        children: Content.values
            .map((c) => _buildContentsCardWidget(c))
            .separateH(height: 20.0.h),
      ),
    );
  }
}