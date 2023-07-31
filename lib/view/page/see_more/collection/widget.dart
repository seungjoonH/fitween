import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/page/see_more/collection/collection.dart';
import 'package:fitween/presenter/page/see_more/see_more.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CollectionMainView extends StatelessWidget {
  const CollectionMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CollectionP>(
      builder: (collectionP) {
        final refreshCont = RefreshController();
        final userP = Get.find<UserCollectionP>();
        FUserCollection user = userP.loggedUser;

        return SmartRefresher(
          controller: refreshCont,
          onRefresh: () async {
            try {
              await SeeMoreP.init();
              refreshCont.refreshCompleted();
            } catch (e) {
              refreshCont.refreshFailed();
            }
          },
          onLoading: () async {
            await Future.delayed(const Duration(milliseconds: 100));
            refreshCont.loadComplete();
          },
          header: const MaterialClassicHeader(
            color: FTheme.black,
            backgroundColor: FTheme.surface,
            offset: 40.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.0.w,
                    vertical: 28.0.h,
                  ),
                  child: Column(
                    children: [
                      FCard(
                        title: FText(Lang.tr('badge.main')),
                        constraints: BoxConstraints(minHeight: 150.0.h),
                        child: Center(
                          child: FCollectionWidget(
                            collection: userP.loggedUser.collection,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0.h),
                      MyCollectionCard(
                        title: FText(
                          Lang.tr('badge.rec-acq'),
                          style: textTheme(context).titleSmall,
                        ),
                        collections: user.orderedCollections,
                        size: 80.0,
                      ),
                      /*
                      const SizedBox(height: 20.0),
                      MyCollectionCard(
                        title: FTexts(
                          const ['이동한 거리', '에 따라 뱃지를 획득했어요'],
                          colors: [ActivityType.distance.color, FTheme.darkGrey],
                          alignment: MainAxisAlignment.start,
                          style: textTheme(context).titleSmall,
                          space: false,
                        ),
                        collections: user.distanceCollections,
                      ),
                      const SizedBox(height: 20.0),
                      MyCollectionCard(
                        title: FTexts(
                          const ['오른 높이', '에 따라 뱃지를 획득했어요'],
                          colors: [ActivityType.height.color, FTheme.darkGrey],
                          alignment: MainAxisAlignment.start,
                          style: textTheme(context).titleSmall,
                          space: false,
                        ),
                        collections: user.heightCollections,
                      ),
                      const SizedBox(height: 20.0),
                      MyCollectionCard(
                        title: FTexts(
                          const ['운동한 양', '에 따라 뱃지를 획득했어요'],
                          colors: [ActivityType.weight.color, FTheme.darkGrey],
                          alignment: MainAxisAlignment.start,
                          style: textTheme(context).titleSmall,
                          space: false,
                        ),
                        collections: user.weightCollections,
                      ),
                      */
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class MyCollectionCard extends StatelessWidget {
  const MyCollectionCard({
    Key? key,
    required this.title,
    required this.collections,
    this.size = 45.0,
  }) : super(key: key);

  final Widget title;
  final List<Collection> collections;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CollectionP>(
      builder: (collectionP) {
        final userP = Get.find<UserCollectionP>();

        return FCard(
          title: title,
          constraints: BoxConstraints(minHeight: 250.0.h),
          child: SizedBox(
            height: (size * 1.2 + 70.0).h,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: collections.length,
              itemBuilder: (context, index) => FCollectionWidget(
                collection: collections[index],
                size: size,
                onPressed: () => collectionP.collectionPressed(collections[index]),
                selected: userP.loggedUser.badgeId == collections[index].badgeId,
                onLongPressed: () => collectionP.setMainBadge(collections[index]),
              ),
              separatorBuilder: (context, index) => SizedBox(width: (size / 2.6).w),
            ),
          ),
        );
      }
    );
  }
}
