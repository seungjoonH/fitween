import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BadgeManagementCard extends StatelessWidget {
  const BadgeManagementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCollection = Get.find<UserCollectionP>();
    FBadge badge = BadgeJsonP.getBadge(userCollection.loggedUser.badgeId!)!;

    return FCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FText(
                '뱃지 관리',
                color: FTheme.lightGrey,
                style: textTheme.bodyLarge,
                bold: true,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: FTheme.lightGrey,
                size: 20.0,
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FBadgeWidget(badge: badge, size: 96.0),
                    const SizedBox(height: 5.0),
                    FText(badge.title!, style: textTheme.bodyMedium),
                    const SizedBox(height: 5.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: FTheme.darkGrey,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: FText(
                        '대표',
                        color: FTheme.white,
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(
                  color: FTheme.stroke,
                  thickness: .5,
                  width: 40.0,
                ),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FText(
                          '최근',
                          style: textTheme.bodyMedium,
                          color: FTheme.lightGrey,
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Column(
                              children: [
                                FBadgeWidget(size: 48.0),
                                const SizedBox(height: 5.0),
                                FText(badge.title!, style: textTheme.bodyMedium),
                              ],
                            ),
                            const SizedBox(width: 20.0),
                            Column(
                              children: [
                                FBadgeWidget(size: 48.0),
                                const SizedBox(height: 5.0),
                                FText(badge.title!, style: textTheme.bodyMedium),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
