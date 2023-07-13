/* 챌린지 디테일 위젯 */

import 'package:fitween/global/number.dart';
import 'package:fitween/presenter/page/contents/challenge/challenge_detail.dart';
import 'package:fitween/presenter/page/contents/contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/json/challenge.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';

// 챌린지 디테일 리스트 뷰
class ChallengeDetailView extends StatelessWidget {
  const ChallengeDetailView({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final size = MediaQuery.of(context).size;
        final contentsP = Get.find<ContentsP>();
        final challengeDetailP = Get.find<ChallengeDetailP>();

        bool isPortrait = orientation == Orientation.portrait;

        FButton joinButton = FButton(
          onPressed: contentsP.challengeJoinButtonPressed,
          stretch: true,
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
            vertical: 16.0.h,
          ),
          multiple: isPortrait,
          backgroundColor: FTheme.darkGrey,
          child: FText(
            '챌린지 참여하기',
            style: textTheme(context).bodyLarge,
            color: FTheme.white,
            bold: true,
          ),
        );

        FButton createButton = FButton(
          onPressed: () => challengeDetailP
              .challengeCreateButtonPressed(challenge),
          stretch: true,
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
            vertical: 16.0.h,
          ),
          backgroundColor: challenge.type!.color,
          multiple: isPortrait,
          child: FText(
            '챌린지 생성하기',
            style: textTheme(context).bodyLarge,
            bold: true,
            color: FTheme.white,
          ),
        );

        Widget buttonWidget = isPortrait ? Row(
          children: [joinButton, SizedBox(width: 20.0.w), createButton],
        ) : Column(
          children: [joinButton, SizedBox(height: 20.0.h), createButton],
        );

        Widget detailWidget = Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
            vertical: 20.0.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FText(
                    '최대인원 | ${challenge.levels['easy']['maxMember']}명',
                    style: textTheme(context).bodyMedium,
                    color: FTheme.lightGrey,
                  ),
                  SizedBox(width: 20.0.w),
                  FText(
                    '마감기한 | D${withSign(challenge.period!)}',
                    style: textTheme(context).bodyMedium,
                    color: FTheme.lightGrey,
                  ),
                ],
              ),
              SizedBox(height: 4.0.h),
              FText(
                challenge.title!,
                style: textTheme(context).titleLarge,
                bold: true,
                color: FTheme.black,
                maxLines: 2,
              ),
              SizedBox(height: 12.0.h),
              FText(
                challenge.descriptions['detail']!
                    .replaceAll('##', challenge.word),
                style: textTheme(context).bodyLarge,
                color: FTheme.black,
                maxLines: 5,
              ),
              SizedBox(height: 20.0.h),
              buttonWidget,
            ],
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isPortrait) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: size.height * .4,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.0.r),
                        width: 100.0.w,
                        height: 8.0.r,
                        decoration: BoxDecoration(
                          color: FTheme.lightGrey,
                          borderRadius: BorderRadius.circular(3.5.r),
                        ),
                      ),
                      detailWidget,
                    ],
                  ),
                );
              },
            ).whenComplete(() => Get.back());
          }
          else {
            showGeneralDialog(
              barrierLabel: 'barrier',
              barrierDismissible: true,
              barrierColor: FTheme.black.withOpacity(0.5),
              transitionDuration: const Duration(milliseconds: 300),
              context: context,
              pageBuilder: (context, _, __) {
                return Container(
                  color: FTheme.white,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20.0.r),
                        width: 8.0.r,
                        height: 100.0.h,
                        decoration: BoxDecoration(
                          color: FTheme.lightGrey,
                          borderRadius: BorderRadius.circular(3.5.r),
                        ),
                      ),
                      Container(
                        width: size.width * .45,
                        alignment: Alignment.centerLeft,
                        child: detailWidget,
                      ),
                    ],
                  ),
                );
              },
              transitionBuilder: (context, animation, _, child) {
                return SlideTransition(
                  position: Tween(
                    begin: const Offset(1.0, .0),
                    end: const Offset(.5, .0),
                  ).animate(animation),
                  child: child,
                );
              },
            ).whenComplete(() => Get.back());
          }
        });

        return Hero(
          tag: challenge.id!,
          child: Image.asset(
            challenge.imageUrls['default'],
            width: size.width * (isPortrait ? 1 : .5),
            height: size.height * (isPortrait ? .6 : 1),
            fit: BoxFit.cover,
          ),
        );
      }
    );
  }
}
