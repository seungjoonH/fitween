import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PartyCard extends ChallengeCard {
  const PartyCard({super.key, this.party});

  final Party? party;

  @override
  bool get bookmarked => false;

  @override
  Challenge? get challenge => party!.challenge;

  @override
  String get imageUrl => party!.challenge!.defaultImageUrl;

  @override
  String get title => party!.challenge!.title;

  @override
  String get description => party!.detailDescription;

  String get difficultyText => LangCont.tr('word.difficulty');
  String get maxMemberText => LangCont.tr('word.max-member');
  String get dueText => LangCont.tr('word.due');
  String get goalText => LangCont.tr('word.goal');

  Widget _buildPartyInfoWidget(BuildContext context) {
    FText buildText(String text) => FText(
      text,
      color: FTheme.comment,
      style: FTheme.commentStyle,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildText('$difficultyText | '),
            FTag(
              party!.difficulty.locale,
              backgroundColor: party!.type.color,
            ),
          ],
        ),
        Divider(thickness: 1, color: FTheme.comment),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildText('$maxMemberText | ${party!.maxMemberCount}'),
            buildText('$dueText | ${party!.deadline}'),
            buildText('$goalText | ${party!.type.withAltUnit(party!.goal)}'),
          ],
        ),
        Divider(thickness: 1, color: FTheme.comment),
      ],
    );
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: [
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
    double percent = widget.party?.percent ?? .0;
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
