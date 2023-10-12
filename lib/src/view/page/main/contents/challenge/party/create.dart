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
    return Obx(() => Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Image.asset(
          cont.challenge!.defaultImageUrl,
          width: PageCont.size.width,
          height: PageCont.size.height * .25,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, object, stacktrace) {
            return Image.asset(
              ImageCont.emptyAssetPath,
              width: PageCont.size.width,
              height: PageCont.size.height * .25,
              fit: BoxFit.fitWidth,
            );
          },
        ),
        Container(
          width: PageCont.size.width,
          height: PageCont.size.height * .25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                FTheme.background.withOpacity(1.0),
                FTheme.background.withOpacity(.0),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0.w),
          child: FText(
            cont.challenge!.title,
            style: FTheme.headlineMedium,
            maxLines: 0,
          ),
        ),
      ],
    ));
  }

  Widget _buildHeaderWidget(BuildContext context, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FText(text, style: FTheme.commentStyle, color: FTheme.bar, bold: true),
        Divider(thickness: .5, color: FTheme.comment),
      ],
    );
  }

  Widget _buildPartyTitleFieldWidget(BuildContext context) {
    return Column(
      children: [
        _buildHeaderWidget(context, cont.partyTitleHeaderText),
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
        _buildHeaderWidget(context, cont.difficultyHeaderText),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Difficulty.values.map((d) {
            bool selected = cont.difficulty == d;
            Color color = selected
                ? cont.challenge!.type.color
                : FTheme.comment;
            return FTextButton(
              text: d.locale.capitalize,
              textColor: color,
              style: FTheme.titleMedium,
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
        _buildHeaderWidget(context, cont.descriptionHeaderText),
        FTexts(
          cont.challenge!.getDetailDescription(
            difficulty: cont.difficulty,
            txs: true,
          ),
          textColor: FTheme.outline,
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
            Icon(Icons.flag, color: FTheme.comment),
            SizedBox(width: 5.0.w),
            FText(
              cont.goalTitle,
              style: FTheme.titleMedium,
              color: FTheme.comment,
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.people_alt, color: FTheme.comment),
            SizedBox(width: 5.0.w),
            FText(
              cont.maxMemberTitle,
              style: FTheme.titleMedium,
              color: FTheme.comment,
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.date_range, color: FTheme.comment),
            SizedBox(width: 5.0.w),
            FText(
              cont.periodTitle,
              style: FTheme.titleMedium,
              color: FTheme.comment,
            ),
          ],
        ),
        Row(
          children: [
            const FPointWidget(grey: true),
            SizedBox(width: 5.0.w),
            FText(
              cont.pointTitle,
              style: FTheme.titleMedium,
              color: FTheme.comment,
            ),
          ],
        ),
      ].separateH(height: 10.0.h),
    );
  }

  Widget _buildValueColumnWidget(BuildContext context) {
    Color color = FTheme.outline;
    return Column(
      children: [
        Row(
          children: [
            FText(
              cont.goalValueText,
              style: FTheme.titleMedium,
              color: color,
            ),
          ],
        ),
        Row(
          children: [
            FText(
              cont.maxMemberValueText,
              style: FTheme.titleMedium,
              color: color,
            ),
          ],
        ),
        Row(
          children: [
            FText(
              cont.periodValueText,
              style: FTheme.titleMedium,
              color: color,
            ),
          ],
        ),
        Row(
          children: [
            FText(
              cont.pointValueText,
              style: FTheme.titleMedium,
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
        _buildHeaderWidget(context, cont.infoHeaderText),
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
                color: FTheme.comment,
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
                    backgroundColor: cont.challenge!.type.color,
                    onPressed: cont.createPartyButtonPressed,
                    stretch: true,
                  ),
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
