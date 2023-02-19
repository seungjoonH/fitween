import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/enum/page_mode.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/collection/main.dart';
import 'package:fitween/view/widget/widget/badge.dart';

class CollectionMainView extends StatelessWidget {
  const CollectionMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CollectionMainP>(
      builder: (collectionMainP) {
        final userP = Get.find<UserCollectionP>();
        FUserCollection user = userP.loggedUser;
        const collectionCounts = 200;

        List<Widget> collectionWidgets = user.orderedCollections.map((collection) {
          return Center(
            child: CollectionWidget(
              collection: collection,
              detail: true,
              size: 100.0,
              onPressed: () => collectionMainP.collectionPressed(collection),
              onLongPressed: () => collectionMainP.setMainBadge(collection),
              pressed: collectionMainP.mode == PageMode.edit
                  && collectionMainP.selectedBadgeId == collection.badgeId,
              selected: collectionMainP.mode == PageMode.view
                  && user.badgeId == collection.badgeId,
            ),
          );
        }).toList()..addAll(
          BadgePresenter.notAcquiredBadges.map((badge) => Center(
            child: BadgeWidget(
              badge: badge,
              detail: true,
              size: 100.0,
              greyscale: true,
              lock: true,
            ),
          ),
        ));

        List<Widget> emptyWidgets = List.generate(
          (collectionCounts - collectionWidgets.length).toInt(),
              (_) => Center(child: CollectionWidget(size: 100.0)),
        ).toList();

        List<Widget> gridWidgets = collectionWidgets..addAll(emptyWidgets);

        return GridView(
          padding: const EdgeInsets.all(20.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: .6,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          children: gridWidgets,
        );
      }
    );
  }
}
