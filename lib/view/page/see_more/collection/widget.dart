import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/page/see_more/collection/collection.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/model/enum/page_mode.dart';
import 'package:fitween/view/widget/widget/badge.dart';

class CollectionMainView extends StatelessWidget {
  const CollectionMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CollectionP>(
      builder: (collectionP) {
        final userP = Get.find<UserCollectionP>();
        FUserCollection user = userP.loggedUser;

        // List<Widget> collectionWidgets = user.recentCollections.map((collection) {
        //   return Center(
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 20.0),
        //       child: CollectionWidget(
        //         collection: collection,
        //         detail: true,
        //         size: 100.0,
        //         onPressed: () => collectionP.collectionPressed(collection),
        //         onLongPressed: () => collectionP.setMainBadge(collection),
        //         pressed: collectionP.mode == PageMode.edit
        //             && collectionP.selectedBadgeId == collection.badgeId,
        //         selected: collectionP.mode == PageMode.view
        //             && user.badgeId == collection.badgeId,
        //       ),
        //     ),
        //   );
        // }).toList()..addAll(
        //   BadgeJsonP.notAcquiredBadges.map((badge) => Center(
        //     child: BadgeWidget(
        //       badge: badge,
        //       detail: true,
        //       size: 100.0,
        //       greyscale: true,
        //       lock: true,
        //     ),
        //   ),
        // ));

        List<Widget> recentCollectionWidgets = user.recentCollections.map((collection) {
          return Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0.r, 0.0.r, 20.0.r, 0.0.r),
              child: CollectionWidget(
                collection: collection,
                detail: true,
                size: 100.0,
                onPressed: () => collectionP.collectionPressed(collection),
                onLongPressed: () => collectionP.setMainBadge(collection),
                pressed: collectionP.mode == PageMode.edit
                    && collectionP.selectedBadgeId == collection.badgeId,
                selected: collectionP.mode == PageMode.view
                    && user.badgeId == collection.badgeId,
              ),
            ),
          );
        }).toList();

        List<Widget> dailyCollectionWidgets = user.dailyCollections.map((collection) {
          return Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0.r, 0.0.r, 20.0.r, 0.0.r),
              child: CollectionWidget(
                collection: collection,
                detail: true,
                size: 100.0,
                onPressed: () => collectionP.collectionPressed(collection),
                onLongPressed: () => collectionP.setMainBadge(collection),
                pressed: collectionP.mode == PageMode.edit
                    && collectionP.selectedBadgeId == collection.badgeId,
                selected: collectionP.mode == PageMode.view
                    && user.badgeId == collection.badgeId,
              ),
            ),
          );
        }).toList();

        List<Widget> challengeCollectionWidgets = user.challengeCollections.map((collection) {
          return Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0.r, 0.0.r, 20.0.r, 0.0.r),
              child: CollectionWidget(
                collection: collection,
                detail: true,
                size: 100.0,
                onPressed: () => collectionP.collectionPressed(collection),
                onLongPressed: () => collectionP.setMainBadge(collection),
                pressed: collectionP.mode == PageMode.edit
                    && collectionP.selectedBadgeId == collection.badgeId,
                selected: collectionP.mode == PageMode.view
                    && user.badgeId == collection.badgeId,
              ),
            ),
          );
        }).toList();

        // List<Widget> emptyWidgets = List.generate(
        //   (collectionCounts - collectionWidgets.length).toInt(),
        //       (_) => Center(child: CollectionWidget(size: 100.0)),
        // ).toList();

        // List<Widget> gridWidgets = collectionWidgets..addAll(emptyWidgets);

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(28.0.r),
                child: Column(
                  children: [
                    FCard(
                      padding: EdgeInsets.all(20.0.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FText('최근에 획득한 뱃지에요', color: FTheme.darkGrey),
                          SizedBox(height: 20.0.h),
                          SizedBox(
                            height: 160.0.h,
                            child: recentCollectionWidgets.isEmpty
                                ? Center(child: FText('최근에 획득한 뱃지가 없어요!'))
                                : ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: recentCollectionWidgets,
                            )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0.h),
                    FCard(
                      padding: EdgeInsets.all(20.0.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FText('일일 목표로 획득한 뱃지에요'),
                          SizedBox(height: 20.0.h),
                          SizedBox(
                            height: 160.0.h,
                            child: dailyCollectionWidgets.isEmpty
                                ? Center(child: FText('일일 목표를 달성해보세요!'))
                                : ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: dailyCollectionWidgets,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0.h),
                    FCard(
                      padding: EdgeInsets.all(20.0.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FText('월간 챌린지로 획득한 뱃지에요'),
                          SizedBox(height: 20.0.h),
                          SizedBox(
                            height: 160.0.h,
                            child: challengeCollectionWidgets.isEmpty
                                ? Center(child: FText('월간 챌린지에 도전해보세요!'))
                                : ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: challengeCollectionWidgets,
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: GridView(
              //     padding: const EdgeInsets.all(20.0),
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 3,
              //       childAspectRatio: .6,
              //       mainAxisSpacing: 10.0,
              //       crossAxisSpacing: 10.0,
              //     ),
              //     children: gridWidgets,
              //   ),
              // ),
            ],
          ),
        );
      }
    );
  }
}
