/* 챌린지 디테일 위젯 */

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
    final contentsP = Get.find<ContentsP>();
    final challengeDetailP = Get.find<ChallengeDetailP>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 320.0,
            // color: Colors.amber,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  width: 100.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    // border: Border.all(color: FTheme.black, width: 1.5),
                    color: FTheme.lightGrey,
                    borderRadius: BorderRadius.circular(3.5),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 28.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          FText(
                            '최대인원 | ${challenge.levels['easy']['maxMember']}명',
                            style: textTheme.bodyMedium,
                            color: FTheme.lightGrey,
                          ),
                          SizedBox(width: 20.0.w),
                          FText(
                            '마감기한 | D-${challenge.period}',
                            style: textTheme.bodyMedium,
                            color: FTheme.lightGrey,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0.h),
                      FText(
                        challenge.title!,
                        align: TextAlign.center,
                        style: textTheme.titleLarge,
                        bold: true,
                        color: FTheme.black,
                        maxLines: 2,
                      ),
                      SizedBox(height: 12.0.h),
                      FText(
                        challenge.descriptions['detail']!
                            .replaceAll('##', challenge.word),
                        // align: TextAlign.center,
                        style: textTheme.bodyLarge,
                        color: FTheme.black,
                        maxLines: 5,
                      ),
                      SizedBox(height: 20.0.h),
                      Row(
                        children: [
                          FButton(
                            onPressed: contentsP.challengeJoinButtonPressed,
                            stretch: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0.w,
                              vertical: 16.0.h,
                            ),
                            // textColor: FTheme.black,
                            multiple: true,
                            backgroundColor: FTheme.white,
                            border: true,
                            child: FText(
                              '챌린지 참여하기',
                              style: textTheme.titleSmall,
                              bold: true,
                            ),
                          ),
                          SizedBox(width: 20.0.w),
                          FButton(
                            onPressed: () => challengeDetailP
                                .challengeCreateButtonPressed(challenge),
                            stretch: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0.w,
                              vertical: 16.0.h,
                            ),
                            multiple: true,
                            child: FText(
                              '챌린지 생성하기',
                              style: textTheme.titleSmall,
                              bold: true,
                              color: FTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ).whenComplete(() => Get.back());
    });

    return Hero(
      tag: challenge.id!,
      child: Image.asset(
        challenge.imageUrls['default'],
        height: 700.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
