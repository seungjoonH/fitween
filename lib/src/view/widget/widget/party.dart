import 'dart:math';

import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
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
    this.showPercent = false,
  });

  final Party? party;
  final VoidCallback? onPressed;
  final bool showPercent;

  Widget get titleWidget => FText(
    party!.title,
    color: ThemeCont.to.text,
    maxLines: 2,
    bold: true,
  );

  Widget get subtitleWidget {
    String leader = LangCont.tr('word.leader');
    String nickname = party!.leaderNickname;

    return FText(
      '$leader: $nickname',
      color: ThemeCont.to.comment,
      style: ThemeCont.to.bodyMedium,
      maxLines: 3,
    );
  }

  Color get stampColor => party!.completed
      ? ThemeCont.colorA
      : ThemeCont.colorB;

  @override
  Widget build(BuildContext context) {
    return FListTile(
      onPressed: onPressed,
      leading: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80.0.w,
            height: double.infinity,
            child: Image.asset(
              party!.challenge!.defaultImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              color: ThemeCont.achro5.withOpacity(.3),
              child: Transform.rotate(
                angle: -pi * .25,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0.w,
                    vertical: 2.0.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: stampColor,
                      width: 3.0,
                    ),
                  ),
                  child: FText(
                    party!.finishState,
                    color: stampColor,
                    style: ThemeCont.to.titleMedium,
                    bold: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(.0, .0, 10.0.r, .0),
      titleWidget: titleWidget,
      subtitleWidget: subtitleWidget,
      tags: [
        FTypeTag(type: party!.type),
        FTextTag(
          party!.deadline,
          backgroundColor: party!.over ? null : ThemeCont.to.text,
        ),
        DifficultyTag(difficulty: party!.difficulty),
      ],
      backgroundColor: ThemeCont.to.backgroundAlt,
      trailing: [
        if (showPercent)
        FCircularPercentIndicator(
          percent: min(party!.percent, 1.0),
          progressColor: party!.type.color,
          enableCenter: true,
        ),
      ],
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
    style: ThemeCont.to.titleMedium
        ?.copyWith(fontWeight: FontWeight.bold),
    highlightStyle: ThemeCont.to.titleMedium?.copyWith(
      color: ThemeCont.colorA,
      fontWeight: FontWeight.bold,
    ),
    wordWrap: true,
  );

  @override
  Widget get subtitleWidget {
    String leader = LangCont.tr('word.leader').capitalize!;
      return FTexts(
      '$leader: $leaderNicknameTxs',
      style: ThemeCont.to.bodyMedium,
      textColor: ThemeCont.to.comment,
      highlightStyle: ThemeCont.to.bodyMedium?.copyWith(
        color: ThemeCont.colorA,
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
            size: 18.0,
            iconSize: 17.0,
            iconColor: ThemeCont.to.comment,
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
              style: ThemeCont.to.cardTitleStyle,
              maxLines: 0,
            ),
          ),
          SizedBox(width: 3.0.r),
          FIconButton(
            icon: const Icon(Icons.edit),
            size: 28.0,
            iconSize: 18.0,
            iconColor: ThemeCont.to.comment,
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
      color: ThemeCont.to.comment,
      style: ThemeCont.to.commentStyle,
    );

    return Column(
      children: [
        Divider(thickness: 1, color: ThemeCont.to.comment),
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
        Divider(thickness: 1, color: ThemeCont.to.comment),
      ],
    );
  }

  Widget _buildPartyTitleWidget(BuildContext context) {
    return FText(
      party!.challenge!.title,
      style: ThemeCont.to.titleSmall,
      color: ThemeCont.to.comment,
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
    this.type,
    this.party,
    this.onPressed,
  });

  final FType? type;
  final Party? party;
  final VoidCallback? onPressed;

  Color get defaultColor => Color.alphaBlend(
    type?.color.withOpacity(.35) ?? ThemeCont.to.bar,
    ThemeCont.to.backgroundAlt,
  );
  IconData? get iconData => Icons.add;

  @override
  State<PartyWidget> createState() => _PartyWidgetState();
}

class _PartyWidgetState extends State<PartyWidget> with ScalePressable {
  @override
  Widget buildContent(BuildContext context) {
    double size = 70.0.r;
    double percent = min(widget.party?.percent ?? .0, 1.0);
    if (widget.party == null) percent = .02;
    Color color = widget.party?.type.color ?? widget.defaultColor;

    Widget imageWidget = widget.party == null ? Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.defaultColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.iconData,
        size: 35.0.r,
        color: ThemeCont.to.background,
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
          backgroundColor: widget.defaultColor,
          progressColor: color,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ],
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}

class PartyHistoryWidget extends PartyWidget {
  const PartyHistoryWidget({
    super.key,
    super.onPressed,
  });

  @override
  IconData? get iconData => Icons.history;

  @override
  Color get defaultColor => ThemeCont.to.bar;

}
