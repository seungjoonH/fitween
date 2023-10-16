import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PartyListTile extends StatelessWidget {
  const PartyListTile({
    super.key,
    this.party,
    this.onPressed,
  });

  final Party? party;
  final VoidCallback? onPressed;

  Widget get titleWidget => FText(
    party!.title,
    color: FTheme.text,
    maxLines: 2,
    bold: true,
  );

  Widget get subtitleWidget {
    String title = party!.challenge!.title;
    String leader = LangCont.tr('word.leader');
    String nickname = party!.leaderNickname;

    return FText(
      '$title\n$leader: $nickname',
      color: FTheme.comment,
      style: FTheme.bodyMedium,
      maxLines: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FListTile(
      onPressed: onPressed,
      leading: SizedBox(
        width: 80.0.w,
        height: double.infinity,
        child: Image.asset(
          party!.challenge!.defaultImageUrl,
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.fromLTRB(.0, .0, 10.0.r, .0),
      titleWidget: titleWidget,
      subtitleWidget: subtitleWidget,
      tags: [
        FTypeTag(type: party!.type),
        FTextTag(
          party!.deadline,
          backgroundColor: party!.over ? null : FTheme.text,
        ),
        DifficultyTag(difficulty: party!.difficulty),
      ],
      backgroundColor: FTheme.backgroundAlt,
    );
  }
}

class PartySearchedListTile extends PartyListTile {
  const PartySearchedListTile({
    super.key,
    required this.keyword,
    this.searchedType,
    super.party,
    super.onPressed,
  });

  final String keyword;
  final PartySearchedType? searchedType;

  String get titleTxs {
    String title = super.party!.title;
    if (searchedType != PartySearchedType.title) return title;
    return title.replaceFirst(keyword, '@{$keyword}');
  }

  String get leaderNicknameTxs {
    String nickname = super.party!.leaderNickname;
    if (searchedType != PartySearchedType.leaderNickname) return nickname;
    return nickname.replaceFirst(keyword, '@{$keyword}');
  }

  @override
  Widget get titleWidget => FTexts(
    titleTxs,
    style: FTheme.titleMedium
        ?.copyWith(fontWeight: FontWeight.bold),
    highlightStyle: FTheme.titleMedium?.copyWith(
      color: FTheme.colorA,
      fontWeight: FontWeight.bold,
    ),
    wordWrap: true,
  );

  @override
  Widget get subtitleWidget {
    String leader = LangCont.tr('word.leader').capitalize!;
      return FTexts(
      '$leader: $leaderNicknameTxs',
      style: FTheme.bodyMedium,
      textColor: FTheme.comment,
      highlightStyle: FTheme.bodyMedium?.copyWith(
        color: FTheme.colorA,
        fontWeight: FontWeight.bold,
      ),
    );
  }

}

class PartyCard extends ChallengeCard {
  const PartyCard({
    super.key,
    this.party,
    required this.titleController,
    this.titleEditMode = false,
    this.onTitleChanged,
    this.toggleTitleMode,
  });

  final Party? party;
  final TextEditingController titleController;
  final bool titleEditMode;
  final Function(String)? onTitleChanged;
  final VoidCallback? toggleTitleMode;

  @override
  bool get bookmarked => false;

  @override
  Challenge? get challenge => party!.challenge;

  @override
  String get imageUrl => party!.challenge!.defaultImageUrl;

  @override
  Widget get title {
      return IntrinsicHeight(
        child: titleEditMode ? FTextField(
          controller: titleController,
          prefixIcon: FIconButton(
            icon: const Icon(Icons.save),
            size: 18.0.r,
            iconSize: 17.0.r,
            iconColor: FTheme.comment,
            onPressed: toggleTitleMode,
          ),
          hintText: party!.title,
          onChanged: onTitleChanged,
          clearPressed: titleController.clear,
        ) : Row(
        children: [
          Expanded(
            child: FText(
              party!.title,
              style: FTheme.cardTitleStyle,
              maxLines: 0,
            ),
          ),
          SizedBox(width: 3.0.r),
          FIconButton(
            icon: const Icon(Icons.edit),
            size: 28.0.r,
            iconSize: 18.0.r,
            iconColor: FTheme.comment,
            onPressed: toggleTitleMode,
          ),
        ],
    ),
      );
  }

  @override
  String get description => party!.detailDescription;

  String get difficultyText => LangCont.tr('word.difficulty').capitalize!;
  String get maxMemberText => LangCont.tr('word.max-member').capitalize!;
  String get dueText => LangCont.tr('word.due').capitalize!;
  String get typeText => LangCont.tr('word.type').capitalize!;

  Widget _buildPartyInfoWidget(BuildContext context) {
    FText buildText(String text) => FText(
      text,
      color: FTheme.comment,
      style: FTheme.commentStyle,
    );

    return Column(
      children: [
        Divider(thickness: 1, color: FTheme.comment),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText('$maxMemberText | ${party!.maxMemberCount}'),
                  SizedBox(height: 3.0.h),
                  buildText('$dueText | ${party!.deadline}'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      buildText('$difficultyText | '),
                      DifficultyTag(difficulty: party!.difficulty),
                    ],
                  ),
                  SizedBox(height: 3.0.h),
                  Row(
                    children: [
                      buildText('$typeText | '),
                      FTypeTag(type: party!.type),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(thickness: 1, color: FTheme.comment),
      ],
    );
  }

  Widget _buildPartyTitleWidget(BuildContext context) {
    return FText(
      party!.challenge!.title,
      style: FTheme.titleSmall,
      color: FTheme.comment,
      maxLines: 2,
      bold: true,
    );
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPartyTitleWidget(context),
        SizedBox(height: 10.0.h),
        super.buildCardContent(context),
        SizedBox(height: 20.0.h),
        _buildPartyInfoWidget(context),
      ],
    );
  }
}

class PartyWidget extends StatefulWidget {
  const PartyWidget({
    super.key,
    this.party,
    this.onPressed,
  });

  final Party? party;
  final VoidCallback? onPressed;

  @override
  State<PartyWidget> createState() => _PartyWidgetState();
}

class _PartyWidgetState extends State<PartyWidget> with ScalePressable {
  @override
  Widget buildContent(BuildContext context) {
    double size = 70.0.r;
    double percent = min(widget.party?.percent ?? .0, 1.0);
    if (widget.party == null) percent = .02;
    Color color = widget.party?.type.color ?? FTheme.bar;

    Widget imageWidget = widget.party == null ? Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FTheme.bar,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.add,
        size: 35.0.r,
        color: FTheme.background,
      ),
    ) : Image.asset(
      widget.party!.challenge!.defaultImageUrl,
      fit: BoxFit.cover,
      width: size,
      height: size,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.0.r),
          child: imageWidget,
        ),
        CircularPercentIndicator(
          radius: (size * 1.25) * .5,
          lineWidth: 5.0.r,
          percent: percent,
          animation: true,
          backgroundColor: FTheme.bar,
          progressColor: color,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ],
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}
