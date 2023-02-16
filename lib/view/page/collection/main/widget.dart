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
    return GetBuilder<CollectionMain>(
      builder: (controller) {
        final userP = Get.find<UserP>();
        FUser user = userP.loggedUser;
        const collectionCounts = 200;

        List<Widget> collectionWidgets = user.orderedCollections.map((collection) {
          return Center(
            child: CollectionWidget(
              collection: collection,
              detail: true,
              size: 100.0,
              onPressed: () => controller.collectionPressed(collection),
              onLongPressed: () => controller.setMainBadge(collection),
              pressed: controller.mode == PageMode.edit
                  && controller.selectedBadgeId == collection.badgeId,
              selected: controller.mode == PageMode.view
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
