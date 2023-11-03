import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PartyMemberSettingPage extends FPage {
  const PartyMemberSettingPage({super.key});

  @override
  FPageState<PartyMemberSettingPage> createState() => _PartyMemberSettingPageState();
}

class _PartyMemberSettingPageState extends FPageState<PartyMemberSettingPage> {
  @override
  PartyMemberSettingPageCont get cont => PartyMemberSettingPageCont.to;
  PartyPageCont get partyCont => PartyPageCont.to;

  Widget _buildMemberCardWidget(BuildContext context, FUser member) {
    bool isMe = cont.myUid == member.key;
    Widget buildButton({
      required String text,
      Color? backgroundColor,
      Color? textColor,
      VoidCallback? onPressed,
    }) {
      if (isMe) return const SizedBox();
      return FButton(
        text: text,
        style: ThemeCont.to.bodyMedium,
        backgroundColor: backgroundColor,
        textColor: textColor,
        stretch: true,
        shrinkWrap: true,
        onPressed: onPressed,
      );
    }

    return FCard(
      title: FText(member.nickname, style: ThemeCont.to.cardTitleStyle),
      child: Row(
        children: [
          Expanded(
            child: buildButton(
              text: cont.pokeButtonText,
              backgroundColor: ThemeCont.to.unselected,
              onPressed: () => cont.pokeButtonPressed(member),
            ),
          ),
          Expanded(
            child: buildButton(
              text: cont.delegateButtonText,
              onPressed: () => cont.delegateButtonPressed(member),
            ),
          ),
          Expanded(
            child: buildButton(
              text: cont.banishButtonText,
              backgroundColor: ThemeCont.error,
              onPressed: () => cont.banishButtonPressed(member),
            ),
          ),
        ].separateW(width: 10.0.w),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.party == null) return Container();
      return Column(
        children: cont.membersWithoutMe
            .map((member) => _buildMemberCardWidget(context, member))
            .separateH(height: 10.0.h),
      );
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }

}
