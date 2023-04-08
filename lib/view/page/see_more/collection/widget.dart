import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/json/badge.dart';
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

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(28.0.r),
                child: Column(
                  children: [
                    FCard(
                      title: FText('내 대표 컬렉션'),
                      child: Center(
                        child: FCollectionWidget(
                          collection: userP.loggedUser.collection,
                          direction: Axis.horizontal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    MyCollectionCard(
                      title: FText(
                        '최근에 획득한 컬렉션이에요',
                        style: textTheme.titleSmall,
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
                        style: textTheme.titleSmall,
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
                        style: textTheme.titleSmall,
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
                        style: textTheme.titleSmall,
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
          constraints: const BoxConstraints(minHeight: 200.0),
          child: SizedBox(
            height: size * 1.2 + 60.0,
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
              separatorBuilder: (context, index) => SizedBox(width: size / 2.6),
            ),
          ),
        );
      }
    );
  }
}
