import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PartyCreatePage extends FPage {
  const PartyCreatePage({super.key});

  @override
  FPageState<PartyCreatePage> createState() => _PartyCreatePageState();
}

class _PartyCreatePageState extends FPageState<PartyCreatePage> {

  @override
  PartyCreatePageCont get cont => PartyCreatePageCont.to;

  Widget _buildChallengeTitleWidget(BuildContext context) {
    return Obx(() => TopImage(
      imageUrl: cont.challenge!.defaultImageUrl,
      title: cont.challenge!.title,
    ));
  }

  Widget _buildPartyTitleFieldWidget(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(text: cont.partyTitleHeaderText),
        FTextField(
          controller: cont.partyTitleCont,
          hintText: cont.hintTitle,
          onChanged: cont.onFieldChanged,
          clearPressed: cont.clearTitleField,
        ),
      ],
    );
  }

  Widget _buildDifficultySelectionWidget(BuildContext context) {
    return Obx(() => Column(
      children: [
        HeaderWidget(text: cont.difficultyHeaderText),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Difficulty.values.map((d) {
            bool selected = cont.difficulty == d;
            Color color = selected
                ? cont.challenge!.type.color
                : ThemeCont.to.comment;
            return FTextButton(
              text: d.locale.capitalize,
              textColor: color,
              style: ThemeCont.to.titleMedium,
              bold: selected,
              onPressed: () => cont.setDifficulty(d),
            );
          }).toList(),
        ),
      ],
    ));
  }

  Widget _buildDescriptionWidget(BuildContext context) {
    return Obx(() => Column(
      children: [
        HeaderWidget(text: cont.descriptionHeaderText),
        FTexts(
          cont.challenge!.getDetailDescription(
            difficulty: cont.difficulty,
            txs: true,
          ),
          textColor: ThemeCont.to.outline,
          highlightColor: cont.challenge!.type.color,
          wordWrap: true,
        ),
      ],
    ));
  }

  Widget _buildTitleColumnWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.flag, color: ThemeCont.to.comment),
            SizedBox(width: 5.0.w),
            FText(
              cont.goalTitle,
              style: ThemeCont.to.titleMedium,
              color: ThemeCont.to.comment,
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.people_alt, color: ThemeCont.to.comment),
            SizedBox(width: 5.0.w),
            FText(
              cont.maxMemberTitle,
              style: ThemeCont.to.titleMedium,
              color: ThemeCont.to.comment,
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.date_range, color: ThemeCont.to.comment),
            SizedBox(width: 5.0.w),
            FText(
              cont.periodTitle,
              style: ThemeCont.to.titleMedium,
              color: ThemeCont.to.comment,
            ),
          ],
        ),
        Row(
          children: [
            const FPointIcon(grey: true),
            SizedBox(width: 5.0.w),
            FText(
              cont.pointTitle,
              style: ThemeCont.to.titleMedium,
              color: ThemeCont.to.comment,
            ),
          ],
        ),
      ].separateH(height: 10.0.h),
    );
  }

  Widget _buildValueColumnWidget(BuildContext context) {
    Color color = ThemeCont.to.outline;
    return Column(
      children: [
        Row(
          children: [
            FText(
              cont.goalValueText,
              style: ThemeCont.to.titleMedium,
              color: color,
            ),
          ],
        ),
        Row(
          children: [
            FText(
              cont.maxMemberValueText,
              style: ThemeCont.to.titleMedium,
              color: color,
            ),
          ],
        ),
        Row(
          children: [
            FText(
              cont.periodValueText,
              style: ThemeCont.to.titleMedium,
              color: color,
            ),
          ],
        ),
        Row(
          children: [
            FText(
              cont.pointValueText,
              style: ThemeCont.to.titleMedium,
              color: color,
            ),
          ],
        ),
      ].separateH(height: 10.0.h),
    );
  }

  Widget _buildInfoWidget(BuildContext context) {
    return Obx(() => Column(
      children: [
        HeaderWidget(text: cont.infoHeaderText),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTitleColumnWidget(context),
              ),
              VerticalDivider(
                width: 30.0.w,
                thickness: .3,
                color: ThemeCont.to.comment,
              ),
              Expanded(
                flex: 3,
                child: _buildValueColumnWidget(context),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.challenge == null) return Container();
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildChallengeTitleWidget(context),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 28.0.w, vertical: 28.0.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPartyTitleFieldWidget(context),
                  _buildDifficultySelectionWidget(context),
                  _buildDescriptionWidget(context),
                  _buildInfoWidget(context),
                  SizedBox(height: 20.0.h),
                  FButton(
                    text: cont.createPartyText,
                    textColor: ThemeCont.achro95,
                    backgroundColor: cont.challenge!.type.color,
                    onPressed: cont.createPartyButtonPressed,
                    stretch: true,
                  ),
                  SizedBox(height: 100.0.h),
                ].separateH(height: 20.0.h),
              ),
            ),
          ],
        ),
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
      autoPadding: false,
      body: _buildBody(context),
    );
  }
}
