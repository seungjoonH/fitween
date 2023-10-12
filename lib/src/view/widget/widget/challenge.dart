import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChallengeListTile extends StatelessWidget {
  const ChallengeListTile({
    super.key,
    required this.challenge,
  });

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return FListTile(
      leading: SizedBox(
        width: 80.0.w,
        height: double.infinity,
        child: Image.asset(
          challenge.defaultImageUrl,
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.fromLTRB(.0, .0, 10.0.r, .0),
      title: challenge.title,
      subtitle: challenge.subDescription,
      backgroundColor: FTheme.backgroundAlt,
    );
  }
}

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    super.key,
    this.challenge,
    this.bookmarked = false,
    this.onPressed,
  });

  final Challenge? challenge;
  final bool bookmarked;
  final VoidCallback? onPressed;

  ChallengePageCont get cont => ChallengePageCont.to;

  Widget _buildEmptyCard(BuildContext context) {
    return FImageCard(
      backgroundColor: FTheme.card,
      title: FText(
        cont.emptyTitle,
        style: FTheme.cardTitleStyle,
        color: FTheme.comment,
        maxLines: 2,
      ),
      child: FText(
        cont.emptyDescription,
        style: FTheme.commentStyle,
        color: FTheme.comment,
        maxLines: 0,
      ),
    );
  }

  Widget buildCardContent(BuildContext context) {
    return FText(
      description,
      style: FTheme.commentStyle,
      color: FTheme.comment,
      maxLines: 0,
    );
  }

  String get imageUrl => challenge!.defaultImageUrl;
  Widget get title => FText(
    challenge!.title,
    style: FTheme.cardTitleStyle,
    maxLines: 2,
  );
  String get description => challenge!.subDescription;

  @override
  Widget build(BuildContext context) {
    if (challenge == null) return _buildEmptyCard(context);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        FImageCard(
          imageUrl: imageUrl,
          bookmarked: bookmarked,
          iconColor: challenge!.type.color,
          onPressed: onPressed,
          title: title,
          child: buildCardContent(context),
        ),
      ],
    );
  }
}
